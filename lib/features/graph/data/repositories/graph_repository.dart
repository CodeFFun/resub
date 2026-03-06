import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/graph/data/datasources/graph_datasource.dart';
import 'package:resub/features/graph/data/datasources/remote/graph_remote_datasource.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';
import 'package:resub/features/graph/domain/repositories/graph_repository.dart';

final graphRepositoryProvider = Provider<IGraphRepository>((ref) {
  final graphRemoteDatasource = ref.read(graphRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return GraphRepository(
    graphRemoteDatasource: graphRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class GraphRepository implements IGraphRepository {
  final NetworkInfo _networkInfo;
  final IGraphRemoteDatasource _graphRemoteDatasource;

  GraphRepository({
    required NetworkInfo networkInfo,
    required IGraphRemoteDatasource graphRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _graphRemoteDatasource = graphRemoteDatasource;

  @override
  Future<Either<Failure, ShopDashboardOverviewEntity>> getShopOverview() async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _graphRemoteDatasource.getShopOverview();
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
