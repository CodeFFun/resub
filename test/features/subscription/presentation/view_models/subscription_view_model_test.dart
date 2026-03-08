import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/subscription/data/repositories/subscription_plan_repository.dart';
import 'package:resub/features/subscription/data/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_plan_repository.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/presentation/state/subscription_state.dart';
import 'package:resub/features/subscription/presentation/view_models/subscription_view_model.dart';

class _FakeSubscriptionRepository implements ISubscriptionRepository {
  @override
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionById(
    String id,
  ) async {
    return const Right(SubscriptionEntity(id: 'sub-1', status: 'active'));
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> createSubscription(
    String shopId,
    SubscriptionEntity subscriptionEntity,
  ) async {
    return Right(subscriptionEntity.copyWith(id: 'created-sub'));
  }

  @override
  Future<Either<Failure, List<SubscriptionEntity>>>
  getAllSubscriptionsOfAUser() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getAllSubscriptionsOfAShop(
    String shopId,
  ) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> updateSubscription(
    String id,
    SubscriptionEntity subscriptionEntity,
  ) async {
    return Right(subscriptionEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteSubscription(String id) async {
    return const Right(true);
  }
}

class _FakeSubscriptionPlanRepository implements ISubscriptionPlanRepository {
  @override
  Future<Either<Failure, SubscriptionPlanEntity>> getSubscriptionPlanById(
    String id,
  ) async {
    return const Right(SubscriptionPlanEntity(id: 'plan-1'));
  }

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> createSubscriptionPlan(
    SubscriptionPlanEntity subscriptionPlanEntity,
  ) async {
    return Right(subscriptionPlanEntity.copyWith(id: 'created-plan'));
  }

  @override
  Future<Either<Failure, List<SubscriptionPlanEntity>>>
  getSubscriptionPlansByShopId(String shopId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> updateSubscriptionPlan(
    String id,
    SubscriptionPlanEntity subscriptionPlanEntity,
  ) async {
    return Right(subscriptionPlanEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteSubscriptionPlan(String id) async {
    return const Right(true);
  }
}

void main() {
  late ProviderContainer container;
  late SubscriptionViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        subscriptionRepositoryProvider.overrideWithValue(
          _FakeSubscriptionRepository(),
        ),
        subscriptionPlanRepositoryProvider.overrideWithValue(
          _FakeSubscriptionPlanRepository(),
        ),
      ],
    );
    viewModel = container.read(subscriptionViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getSubscriptionById sets loaded state with subscription', () async {
      await viewModel.getSubscriptionById(subscriptionId: 'sub-1');

      final state = container.read(subscriptionViewModelProvider);
      expect(state.status, SubscriptionStatus.loaded);
      expect(state.subscription?.id, 'sub-1');
    });
  });

  group('other methods', () {
    test('createSubscription sets created state', () async {
      await viewModel.createSubscription(
        shopId: 'shop-1',
        subscriptionEntity: const SubscriptionEntity(status: 'pending'),
      );

      final state = container.read(subscriptionViewModelProvider);
      expect(state.status, SubscriptionStatus.created);
      expect(state.subscription?.id, 'created-sub');
    });
  });
}
