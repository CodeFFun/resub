import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/order/data/models/order_item_model.dart';
import 'package:resub/features/order/data/datasources/order_item_datasource.dart';

final orderItemRemoteDatasourceProvider = Provider<IOrderItemRemoteDatasource>((
  ref,
) {
  return OrderItemRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class OrderItemRemoteDatasource implements IOrderItemRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  OrderItemRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<OrderItemApiModel> createOrderItem(
    OrderItemApiModel orderItemModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.orderItem,
      data: orderItemModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return OrderItemApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create order item');
    }
  }

  @override
  Future<bool> deleteOrderItem(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.orderItem}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete order item');
    }
  }

  @override
  Future<OrderItemApiModel> getOrderItemById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.orderItem}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return OrderItemApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to get order item');
    }
  }

  @override
  Future<OrderItemApiModel> updateOrderItem(
    String id,
    OrderItemApiModel orderItemModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.orderItem}/$id',
      data: orderItemModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return OrderItemApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update order item');
    }
  }
}
