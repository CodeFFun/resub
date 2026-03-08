import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/graph/data/repositories/graph_repository.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';
import 'package:resub/features/graph/domain/repositories/graph_repository.dart';
import 'package:resub/features/graph/presentation/state/graph_state.dart';
import 'package:resub/features/graph/presentation/view_models/graph_view_model.dart';

class _FakeGraphRepository implements IGraphRepository {
  @override
  Future<Either<Failure, ShopDashboardOverviewEntity>> getShopOverview() async {
    return const Right(
      ShopDashboardOverviewEntity(
        cards: ShopOverviewCardsEntity(
          revenue: 1000,
          orders: 10,
          aov: 100,
          successfulPaymentRate: 95,
        ),
        revenueTrend: [],
        paymentSplit: [],
        topProductsByRevenue: [],
      ),
    );
  }
}

void main() {
  late ProviderContainer container;
  late GraphViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        graphRepositoryProvider.overrideWithValue(_FakeGraphRepository()),
      ],
    );
    viewModel = container.read(graphViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getShopOverview sets loaded state with overview', () async {
      await viewModel.getShopOverview();

      final state = container.read(graphViewModelProvider);
      expect(state.status, GraphStatus.loaded);
      expect(state.overview?.cards.orders, 10);
    });
  });

  group('other methods', () {
    test('initial state is not loaded before fetching', () {
      final state = container.read(graphViewModelProvider);
      expect(state.status, isNot(GraphStatus.loaded));
    });
  });
}
