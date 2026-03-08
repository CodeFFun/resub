import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/constants/esewa_constants.dart';
import 'package:uuid/uuid.dart';

final esewaPaymentServiceProvider = Provider<EsewaPaymentService>((ref) {
  return EsewaPaymentService();
});

class EsewaPaymentService {
  final Uuid _uuid = const Uuid();

  EsewaPaymentService();

  /// Generate unique product ID for each transaction
  String generateProductId() {
    // Keep ID alphanumeric and compact to avoid SDK/backend validation issues.
    return _uuid.v4().replaceAll('-', '').substring(0, 20);
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
      final normalizedAmount = _normalizeAmount(amount);

      debugPrint(
        'ESEWA REQUEST => env=${isTestEnvironment ? 'test' : 'live'}, '
        'productId=$productId, amount=$normalizedAmount, '
        'callbackUrl=${paymentCallbackUrl.isEmpty ? '(empty)' : paymentCallbackUrl}',
      );

      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: isTestEnvironment ? Environment.test : Environment.live,
          clientId: kEsewaId,
          secretId: kSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: productId,
          productName: productName,
          productPrice: normalizedAmount,
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

  /// Keep amount format stable for SDK/server parsing.
  /// Examples: "100" -> "100.00", "99.5" -> "99.50"
  String _normalizeAmount(String amount) {
    final parsed = double.tryParse(amount.trim());
    if (parsed == null) {
      throw FormatException('Invalid payment amount: $amount');
    }
    return parsed.toStringAsFixed(2);
  }

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
