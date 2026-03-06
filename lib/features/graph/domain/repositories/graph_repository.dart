import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';

abstract interface class IGraphRepository {
  Future<Either<Failure, ShopDashboardOverviewEntity>> getShopOverview();
}
