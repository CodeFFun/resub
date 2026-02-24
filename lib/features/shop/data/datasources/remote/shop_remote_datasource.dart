import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/shop/data/datasources/shop_datasource.dart';
import 'package:resub/features/shop/data/models/shop_model.dart';

final shopRemoteDatasourceProvider = Provider<IShopRemoteDatasource>((ref) {
  return ShopRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ShopRemoteDatasource implements IShopRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ShopRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<ShopApiModel> createShop(ShopApiModel shopModel) async {
    final token = await _tokenService.getToken();

    FormData formData = FormData();

    if (shopModel.name != null) formData.fields.add(MapEntry('name', shopModel.name!));
    if (shopModel.pickupInfo != null) formData.fields.add(MapEntry('pickup_info', shopModel.pickupInfo!));
    if (shopModel.about != null) formData.fields.add(MapEntry('about', shopModel.about!));
    if (shopModel.acceptsSubscription != null) {
      formData.fields.add(
        MapEntry(
          'accepts_subscription',
          shopModel.acceptsSubscription.toString(),
        ),
      );
    }
    if (shopModel.addressId != null) formData.fields.add(MapEntry('addressId', shopModel.addressId!));
    if (shopModel.userId != null) formData.fields.add(MapEntry('userId', shopModel.userId!));
    if (shopModel.categoryId != null) formData.fields.add(MapEntry('categoryId', shopModel.categoryId!));

    if (shopModel.shopBannerFile != null) {
      final filename = shopModel.shopBannerFile!.path.split('/').last;
      late String contentType;

      if (filename.endsWith('.jpg') || filename.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (filename.endsWith('.png')) {
        contentType = 'image/png';
      } else if (filename.endsWith('.gif')) {
        contentType = 'image/gif';
      } else {
        contentType = 'image/jpeg'; // Default to JPEG
      }

      formData.files.add(
        MapEntry(
          'shop_banner',
          await MultipartFile.fromFile(
            shopModel.shopBannerFile!.path,
            filename: filename,
            contentType: DioMediaType.parse(contentType),
          ),
        ),
      );
    }

    final response = await _apiClient.post(
      '${ApiEndpoints.shop}/create',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return ShopApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create shop');
    }
  }

  @override
  Future<bool> deleteShop(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.shop}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete shop');
    }
  }

  @override
  Future<List<ShopApiModel>> getAllShops() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.shop}/all',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ShopApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get shops');
    }
  }

  @override
  Future<List<ShopApiModel>> getAllShopsOfAUser() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.shop}/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ShopApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user shops');
    }
  }

  @override
  Future<ShopApiModel> getShopById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.shop}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return ShopApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to get shop');
    }
  }

  @override
  Future<ShopApiModel> updateShop(String id, ShopApiModel shopModel) async {
    final token = await _tokenService.getToken();

    FormData formData = FormData();

    if (shopModel.name != null) formData.fields.add(MapEntry('name', shopModel.name!));
    if (shopModel.pickupInfo != null) formData.fields.add(MapEntry('pickup_info', shopModel.pickupInfo!));
    if (shopModel.about != null) formData.fields.add(MapEntry('about', shopModel.about!));
    if (shopModel.acceptsSubscription != null) {
      formData.fields.add(
        MapEntry(
          'accepts_subscription',
          shopModel.acceptsSubscription.toString(),
        ),
      );
    }
    if (shopModel.addressId != null)  formData.fields.add(MapEntry('addressId', shopModel.addressId!));
    if (shopModel.categoryId != null) formData.fields.add(MapEntry('categoryId', shopModel.categoryId!));

    if (shopModel.shopBannerFile != null) {
      final filename = shopModel.shopBannerFile!.path.split('/').last;
      late String contentType;

      if (filename.endsWith('.jpg') || filename.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (filename.endsWith('.png')) {
        contentType = 'image/png';
      } else if (filename.endsWith('.gif')) {
        contentType = 'image/gif';
      } else {
        contentType = 'image/jpeg'; // Default to JPEG
      }

      formData.files.add(
        MapEntry(
          'shop_banner',
          await MultipartFile.fromFile(
            shopModel.shopBannerFile!.path,
            filename: filename,
            contentType: DioMediaType.parse(contentType),
          ),
        ),
      );
    }

    final response = await _apiClient.patch(
      '${ApiEndpoints.shop}/$id',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return ShopApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update shop');
    }
  }
}
