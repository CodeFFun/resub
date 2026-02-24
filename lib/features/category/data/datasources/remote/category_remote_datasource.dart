import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/category/data/datasources/category_datasource.dart';
import 'package:resub/features/category/data/models/category_model.dart';

final categoryRemoteDatasourceProvider = Provider<ICategoryRemoteDatasource>((
  ref,
) {
  return CategoryRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class CategoryRemoteDatasource implements ICategoryRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  CategoryRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<CategoryApiModel> createProductCategory(
    CategoryApiModel categoryModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      '${ApiEndpoints.productCategory}/create',
      data: categoryModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return CategoryApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create category');
    }
  }

  @override
  Future<bool> deleteProductCategory(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.productCategory}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete category');
    }
  }

  @override
  Future<List<CategoryApiModel>> getAllProductCategories() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.productCategory,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CategoryApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get categories');
    }
  }

  @override
  Future<List<CategoryApiModel>> getAllProductCategoriesByShopId(
    String shopId,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.productCategory}/shop/$shopId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CategoryApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get categories by shop');
    }
  }

  @override
  Future<CategoryApiModel?> getProductCategoryById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.productCategory}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'];
      if (data == null) return null;
      return CategoryApiModel.fromJson(data);
    } else {
      throw Exception('Failed to get category');
    }
  }

  @override
  Future<CategoryApiModel?> updateProductCategory(
    String id,
    CategoryApiModel categoryModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.productCategory}/$id',
      data: categoryModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'];
      if (data == null) return null;
      return CategoryApiModel.fromJson(data);
    } else {
      throw Exception('Failed to update category');
    }
  }

  @override
  Future<List<CategoryApiModel>> getAllShopCategories() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.shopCategory,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CategoryApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get shop categories');
    }
  }
}
