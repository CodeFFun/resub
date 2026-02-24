import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/address/data/models/address_model.dart';
import 'package:resub/features/address/data/datasources/address_datasource.dart';

final addressRemoteDatasourceProvider = Provider<IAddressRemoteDatasource>((
  ref,
) {
  return AddressRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AddressRemoteDatasource implements IAddressRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AddressRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<AddressApiModel> createAddress(AddressApiModel addressModel) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.address,
      data: addressModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return AddressApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create address');
    }
  }

  @override
  Future<bool> deleteAddress(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      '${ApiEndpoints.address}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception('Failed to delete address');
    }
  }

  @override
  Future<AddressApiModel> getAddressById(String id) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.address}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return AddressApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to get address');
    }
  }

  @override
  Future<List<AddressApiModel>> getAllAddressesOfAUser() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.address,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => AddressApiModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get addresses');
    }
  }

  @override
  Future<AddressApiModel> updateAddress(
    String id,
    AddressApiModel addressModel,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.patch(
      '${ApiEndpoints.address}/$id',
      data: addressModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return AddressApiModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update address');
    }
  }
}
