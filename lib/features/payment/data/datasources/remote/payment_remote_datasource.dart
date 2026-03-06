import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/payment/data/models/payment_model.dart';
import 'package:resub/features/payment/data/datasources/payment_datasource.dart';

final paymentRemoteDatasourceProvider = Provider<IPaymentRemoteDatasource>((
  ref,
) {
  return PaymentRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class PaymentRemoteDatasource implements IPaymentRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  PaymentRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<PaymentApiModel> createPayment(PaymentApiModel paymentModel) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.payment,
      data: paymentModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return PaymentApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create payment');
    }
  }

  @override
  Future<PaymentApiModel?> getPaymentById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.payment}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return PaymentApiModel.fromJson(response.data['data']);
    } else {
      return null;
    }
  }

  @override
  Future<List<PaymentApiModel>> getPaymentsByUserId() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.payment}/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => PaymentApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get payments for user');
    }
  }

  @override
  Future<List<PaymentApiModel>> getPaymentsOfShop() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.payment}/shop',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => PaymentApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get payments for shop');
    }
  }

  @override
  Future<PaymentApiModel?> updatePayment(
    String id,
    PaymentApiModel paymentModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.payment}/$id',
      data: paymentModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return PaymentApiModel.fromJson(response.data['data']);
    } else {
      return null;
    }
  }

  @override
  Future<bool> deletePayment(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.payment}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete payment');
    }
  }
}
