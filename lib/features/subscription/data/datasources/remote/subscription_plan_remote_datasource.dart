import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/subscription/data/datasources/subscription_plan_datasource.dart';
import 'package:resub/features/subscription/data/models/subscription_plan_model.dart';

final subscriptionPlanRemoteDatasourceProvider =
    Provider<ISubscriptionPlanRemoteDatasource>((ref) {
      return SubscriptionPlanRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
        tokenService: ref.read(tokenServiceProvider),
      );
    });

class SubscriptionPlanRemoteDatasource
    implements ISubscriptionPlanRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  SubscriptionPlanRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<SubscriptionPlanApiModel> createSubscriptionPlan(
    SubscriptionPlanApiModel subscriptionPlanApiModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.subscriptionPlan,
      data: subscriptionPlanApiModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return SubscriptionPlanApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create subscription plan');
    }
  }

  @override
  Future<bool> deleteSubscriptionPlan(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.subscriptionPlan}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete subscription plan');
    }
  }

  @override
  Future<SubscriptionPlanApiModel> getSubscriptionPlanById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.subscriptionPlan}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return SubscriptionPlanApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to get subscription plan');
    }
  }

  @override
  Future<List<SubscriptionPlanApiModel>> getSubscriptionPlansByShopId(
    String shopId,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.subscriptionPlan}/shop/$shopId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data
          .map((json) => SubscriptionPlanApiModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to get subscription plans by shop');
    }
  }

  @override
  Future<SubscriptionPlanApiModel> updateSubscriptionPlan(
    String id,
    SubscriptionPlanApiModel subscriptionPlanApiModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.subscriptionPlan}/$id',
      data: subscriptionPlanApiModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return SubscriptionPlanApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update subscription plan');
    }
  }
}
