import 'package:resub/features/graph/data/models/shop_dashboard_overview_model.dart';

abstract interface class IGraphRemoteDatasource {
  Future<ShopDashboardOverviewApiModel> getShopOverview();
}
