import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/features/graph/data/datasources/graph_datasource.dart';
import 'package:resub/features/graph/data/models/shop_dashboard_overview_model.dart';

final graphRemoteDatasourceProvider = Provider<IGraphRemoteDatasource>((ref) {
  return GraphRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class GraphRemoteDatasource implements IGraphRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  GraphRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<ShopDashboardOverviewApiModel> getShopOverview() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      '/dashboard/shop/overview',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response for shop overview');
    }

    final responseMap = response.data as Map<String, dynamic>;

    if (responseMap['success'] == true &&
        responseMap['data'] is Map<String, dynamic>) {
      return ShopDashboardOverviewApiModel.fromJson(
        responseMap['data'] as Map<String, dynamic>,
      );
    }

    if (responseMap.containsKey('cards')) {
      return ShopDashboardOverviewApiModel.fromJson(responseMap);
    }

    throw Exception('Failed to get shop overview');
  }
}
