import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/subscription/data/datasources/subscription_datasource.dart';
import 'package:resub/features/subscription/data/models/subscription_model.dart';

final subscriptionRemoteDatasourceProvider =
    Provider<ISubscriptionRemoteDatasource>((ref) {
      return SubscriptionRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
        tokenService: ref.read(tokenServiceProvider),
      );
    });

class SubscriptionRemoteDatasource implements ISubscriptionRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  SubscriptionRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<SubscriptionApiModel> createSubscription(
    String shopId,
    SubscriptionApiModel subscriptionApiModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      '${ApiEndpoints.subscription}/shop/$shopId',
      data: subscriptionApiModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return SubscriptionApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create subscription');
    }
  }

  @override
  Future<bool> deleteSubscription(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.subscription}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete subscription');
    }
  }

  @override
  Future<SubscriptionApiModel> getSubscriptionById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.subscription}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return SubscriptionApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to get subscription');
    }
  }

  @override
  Future<List<SubscriptionApiModel>> getAllSubscriptionsOfAUser() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.subscription}/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => SubscriptionApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get subscriptions by user');
    }
  }

  @override
  Future<List<SubscriptionApiModel>> getAllSubscriptionsOfAShop(
    String shopId,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.subscription}/shop/$shopId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => SubscriptionApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get subscriptions by shop');
    }
  }

  @override
  Future<SubscriptionApiModel> updateSubscription(
    String id,
    SubscriptionApiModel subscriptionApiModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.subscription}/$id',
      data: subscriptionApiModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return SubscriptionApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update subscription');
    }
  }
}
