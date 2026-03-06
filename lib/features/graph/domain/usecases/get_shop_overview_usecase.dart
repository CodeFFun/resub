import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/graph/data/repositories/graph_repository.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';
import 'package:resub/features/graph/domain/repositories/graph_repository.dart';

final getShopOverviewUsecaseProvider = Provider<GetShopOverviewUsecase>((ref) {
  final graphRepository = ref.read(graphRepositoryProvider);
  return GetShopOverviewUsecase(graphRepository: graphRepository);
});

class GetShopOverviewUsecase
    implements UsecaseWithoutParms<ShopDashboardOverviewEntity> {
  final IGraphRepository _graphRepository;

  GetShopOverviewUsecase({required IGraphRepository graphRepository})
    : _graphRepository = graphRepository;

  @override
  Future<Either<Failure, ShopDashboardOverviewEntity>> call() {
    return _graphRepository.getShopOverview();
  }
}
