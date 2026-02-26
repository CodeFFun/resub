import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/order/data/models/order_model.dart';
import 'package:resub/features/order/data/datasources/order_datasource.dart';

final orderRemoteDatasourceProvider = Provider<IOrderRemoteDatasource>((ref) {
  return OrderRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class OrderRemoteDatasource implements IOrderRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  OrderRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<OrderApiModel> createOrder(
    String shopId,
    OrderApiModel orderModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      '${ApiEndpoints.order}/shop/$shopId',
      data: orderModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return OrderApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create order');
    }
  }

  @override
  Future<bool> deleteOrder(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.order}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete order');
    }
  }

  @override
  Future<OrderApiModel> getOrderById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.order}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return OrderApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to get order');
    }
  }

  @override
  Future<List<OrderApiModel>> getOrdersByUserId() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.order}/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => OrderApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get orders by user');
    }
  }

  @override
  Future<List<OrderApiModel>> getOrdersByShopId(String shopId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.order}/shop/$shopId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => OrderApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get orders by shop');
    }
  }

  @override
  Future<List<OrderApiModel>> getOrdersBySubscriptionId(
    String subscriptionId,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.order}/subscription/$subscriptionId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => OrderApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get orders by subscription');
    }
  }

  @override
  Future<OrderApiModel> updateOrder(String id, OrderApiModel orderModel) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.order}/$id',
      data: orderModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return OrderApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update order');
    }
  }
}
