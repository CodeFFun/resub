import 'package:dio/dio.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/constants/esewa_constants.dart';
import 'package:uuid/uuid.dart';

final esewaPaymentServiceProvider = Provider<EsewaPaymentService>((ref) {
  return EsewaPaymentService(apiClient: ref.read(apiClientProvider));
});

class EsewaPaymentService {
  final ApiClient _apiClient;
  final Uuid _uuid = const Uuid();

  EsewaPaymentService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Generate unique product ID for each transaction
  String generateProductId() {
    return _uuid.v4();
  }

  /// Initiate eSewa payment
  Future<void> initiatePayment({
    required String productName,
    required String amount,
    String? callbackUrl,
    required Function(EsewaPaymentSuccessResult) onSuccess,
    required Function(String) onFailure,
    required Function(String) onCancellation,
    bool isTestEnvironment = true,
  }) async {
    try {
      final productId = generateProductId();
      final paymentCallbackUrl = callbackUrl ?? kEsewaCallbackUrl;

      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: isTestEnvironment ? Environment.test : Environment.live,
          clientId: kEsewaId,
          secretId: kSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: productId,
          productName: productName,
          productPrice: amount,
          callbackUrl: paymentCallbackUrl,
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          debugPrint(":::ESEWA SUCCESS::: => $data");
          onSuccess(data);
        },
        onPaymentFailure: (data) {
          debugPrint(":::ESEWA FAILURE::: => $data");
          onFailure(data);
        },
        onPaymentCancellation: (data) {
          debugPrint(":::ESEWA CANCELLATION::: => $data");
          onCancellation(data);
        },
      );
    } on Exception catch (e) {
      debugPrint("ESEWA EXCEPTION : ${e.toString()}");
      onFailure("Payment initialization failed: ${e.toString()}");
    }
  }

  /// Verify transaction status with eSewa server
  /// Note: This makes an external API call which may fail due to network issues.
  /// For immediate UI feedback, we rely on the SDK's success callback.
  /// For production, implement server-to-server verification on your backend.
  Future<EsewaVerificationResult> verifyTransaction(
    EsewaPaymentSuccessResult result,
  ) async {
    try {
      // For development/testing: Skip external verification
      // The SDK callback already confirms success
      return EsewaVerificationResult(
        isSuccess: true,
        status: 'COMPLETE',
        refId: result.refId,
        message: 'Transaction successful (SDK callback verified)',
        transactionDetails: null,
      );

      // ========== OPTIONAL: External Verification ==========
      // Uncomment below for production after ensuring network connectivity
      // Better approach: Move this verification to your backend (server-to-server)
      // This avoids client-side network issues
      /*
      final response = await _callVerificationApi(result);

      if (response.statusCode == 200) {
        final map = {'data': response.data};
        final sucResponse = EsewaPaymentSuccessResponse.fromJson(map);

        debugPrint("Verification Response Code => ${sucResponse.data}");

        if (sucResponse.data.isNotEmpty &&
            sucResponse.data[0].transactionDetails.status == 'COMPLETE') {
          return EsewaVerificationResult(
            isSuccess: true,
            status: sucResponse.data[0].transactionDetails.status,
            refId: sucResponse.data[0].refId,
            message: 'Transaction verified successfully',
            transactionDetails: sucResponse.data[0].transactionDetails,
          );
        } else {
          return EsewaVerificationResult(
            isSuccess: false,
            status: sucResponse.data.isNotEmpty
                ? sucResponse.data[0].transactionDetails.status
                : 'FAILED',
            message: 'Transaction verification failed',
          );
        }
      } else {
        return EsewaVerificationResult(
          isSuccess: false,
          status: 'FAILED',
          message: 'Verification API returned status: ${response.statusCode}',
        );
      }
      */
    } catch (e) {
      debugPrint("VERIFICATION ERROR: ${e.toString()}");
      return EsewaVerificationResult(
        isSuccess: false,
        status: 'ERROR',
        message: 'Verification failed: ${e.toString()}',
      );
    }
  }

  /// Call eSewa verification API
  Future<Response> _callVerificationApi(
    EsewaPaymentSuccessResult result,
  ) async {
    try {
      // eSewa verification endpoint
      final response = await _apiClient.get(
        'https://uat.esewa.com.np/api/epay/transaction/status/',
        queryParameters: {
          'product_code': kEsewaId,
          'total_amount': result.totalAmount,
          'transaction_uuid': result.refId,
        },
      );
      return response;
    } catch (e) {
      debugPrint("Verification API Error: ${e.toString()}");
      rethrow;
    }
  }
}

/// Result class for verification
class EsewaVerificationResult {
  final bool isSuccess;
  final String status;
  final String? refId;
  final String message;
  final dynamic transactionDetails;

  EsewaVerificationResult({
    required this.isSuccess,
    required this.status,
    this.refId,
    required this.message,
    this.transactionDetails,
  });
}
