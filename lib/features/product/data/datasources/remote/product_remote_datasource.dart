import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/product/data/datasources/product_datasource.dart';
import 'package:resub/features/product/data/models/product_model.dart';

final productRemoteDatasourceProvider = Provider<IProductRemoteDatasource>((
  ref,
) {
  return ProductRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProductRemoteDatasource implements IProductRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProductRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<ProductApiModel> createProduct(String shopId, ProductApiModel productModel) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      '${ApiEndpoints.product}/shop/$shopId',
      data: productModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return ProductApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create product');
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.product}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete product');
    }
  }

  @override
  Future<ProductApiModel?> getProductById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.product}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'];
      if (data == null) return null;
      return ProductApiModel.fromJson(data);
    } else {
      throw Exception('Failed to get product');
    }
  }

  @override
  Future<List<ProductApiModel>> getProductsByShopId(String shopId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.product}/shop/$shopId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ProductApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get products by shop');
    }
  }

  @override
  Future<ProductApiModel?> updateProduct(
    String id,
    ProductApiModel productModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.product}/$id',
      data: productModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'];
      if (data == null) return null;
      return ProductApiModel.fromJson(data);
    } else {
      throw Exception('Failed to update product');
    }
  }
}
