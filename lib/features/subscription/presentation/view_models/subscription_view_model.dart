import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/usecases/create_subscription_plan_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/create_subscription_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/delete_subscription_plan_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/delete_subscription_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/get_all_subscriptions_of_a_shop_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/get_all_subscriptions_of_a_user_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/get_subscription_by_id_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/get_subscription_plan_by_id_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/get_subscription_plans_by_shop_id_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/update_subscription_plan_usecase.dart';
import 'package:resub/features/subscription/domain/usecases/update_subscription_usecase.dart';
import 'package:resub/features/subscription/presentation/state/subscription_state.dart';

final subscriptionViewModelProvider =
    NotifierProvider<SubscriptionViewModel, SubscriptionState>(
      () => SubscriptionViewModel(),
    );

class SubscriptionViewModel extends Notifier<SubscriptionState> {
  late final CreateSubscriptionUsecase _createSubscriptionUsecase;
  late final DeleteSubscriptionUsecase _deleteSubscriptionUsecase;
  late final GetSubscriptionByIdUsecase _getSubscriptionByIdUsecase;
  late final GetAllSubscriptionsOfAUserUsecase
  _getAllSubscriptionsOfAUserUsecase;
  late final GetAllSubscriptionsOfAShopUsecase
  _getAllSubscriptionsOfAShopUsecase;
  late final UpdateSubscriptionUsecase _updateSubscriptionUsecase;
  late final CreateSubscriptionPlanUsecase _createSubscriptionPlanUsecase;
  late final DeleteSubscriptionPlanUsecase _deleteSubscriptionPlanUsecase;
  late final GetSubscriptionPlanByIdUsecase _getSubscriptionPlanByIdUsecase;
  late final GetSubscriptionPlansByShopIdUsecase
  _getSubscriptionPlansByShopIdUsecase;
  late final UpdateSubscriptionPlanUsecase _updateSubscriptionPlanUsecase;

  @override
  build() {
    _createSubscriptionUsecase = ref.read(createSubscriptionUsecaseProvider);
    _deleteSubscriptionUsecase = ref.read(deleteSubscriptionUsecaseProvider);
    _getSubscriptionByIdUsecase = ref.read(getSubscriptionByIdUsecaseProvider);
    _getAllSubscriptionsOfAUserUsecase = ref.read(
      getAllSubscriptionsOfAUserUsecaseProvider,
    );
    _getAllSubscriptionsOfAShopUsecase = ref.read(
      getAllSubscriptionsOfAShopUsecaseProvider,
    );
    _updateSubscriptionUsecase = ref.read(updateSubscriptionUsecaseProvider);
    _createSubscriptionPlanUsecase = ref.read(
      createSubscriptionPlanUsecaseProvider,
    );
    _deleteSubscriptionPlanUsecase = ref.read(
      deleteSubscriptionPlanUsecaseProvider,
    );
    _getSubscriptionPlanByIdUsecase = ref.read(
      getSubscriptionPlanByIdUsecaseProvider,
    );
    _getSubscriptionPlansByShopIdUsecase = ref.read(
      getSubscriptionPlansByShopIdUsecaseProvider,
    );
    _updateSubscriptionPlanUsecase = ref.read(
      updateSubscriptionPlanUsecaseProvider,
    );
    return const SubscriptionState();
  }

  // Subscription Methods
  Future<void> createSubscription({
    required String shopId,
    required SubscriptionEntity subscriptionEntity,
  }) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = CreateSubscriptionUsecaseParams(
      shopId: shopId,
      subscriptionEntity: subscriptionEntity,
    );
    final result = await _createSubscriptionUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscription) {
        state = state.copyWith(
          status: SubscriptionStatus.created,
          subscription: subscription,
        );
      },
    );
  }

  Future<void> getSubscriptionById({required String subscriptionId}) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = GetSubscriptionByIdUsecaseParams(id: subscriptionId);
    final result = await _getSubscriptionByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscription) {
        state = state.copyWith(
          status: SubscriptionStatus.loaded,
          subscription: subscription,
        );
      },
    );
  }

  Future<void> getAllSubscriptionsOfAUser() async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final result = await _getAllSubscriptionsOfAUserUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscriptions) {
        state = state.copyWith(
          status: SubscriptionStatus.loaded,
          subscriptions: subscriptions,
        );
      },
    );
  }

  Future<void> getAllSubscriptionsOfAShop({required String shopId}) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = GetAllSubscriptionsOfAShopUsecaseParams(shopId: shopId);
    final result = await _getAllSubscriptionsOfAShopUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscriptions) {
        state = state.copyWith(
          status: SubscriptionStatus.loaded,
          subscriptions: subscriptions,
        );
      },
    );
  }

  Future<void> updateSubscription({
    required String subscriptionId,
    required SubscriptionEntity subscriptionEntity,
  }) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = UpdateSubscriptionUsecaseParams(
      id: subscriptionId,
      subscriptionEntity: subscriptionEntity,
    );
    final result = await _updateSubscriptionUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscription) {
        state = state.copyWith(
          status: SubscriptionStatus.updated,
          subscription: subscription,
        );
      },
    );
  }

  Future<void> deleteSubscription({required String subscriptionId}) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = DeleteSubscriptionUsecaseParams(id: subscriptionId);
    final result = await _deleteSubscriptionUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(status: SubscriptionStatus.deleted);
      },
    );
  }

  // Subscription Plan Methods
  Future<void> createSubscriptionPlan({
    required SubscriptionPlanEntity subscriptionPlanEntity,
  }) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = CreateSubscriptionPlanUsecaseParams(
      subscriptionPlanEntity: subscriptionPlanEntity,
    );
    final result = await _createSubscriptionPlanUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscriptionPlan) {
        state = state.copyWith(
          status: SubscriptionStatus.created,
          subscriptionPlan: subscriptionPlan,
        );
      },
    );
  }

  Future<void> getSubscriptionPlanById({
    required String subscriptionPlanId,
  }) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = GetSubscriptionPlanByIdUsecaseParams(id: subscriptionPlanId);
    final result = await _getSubscriptionPlanByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscriptionPlan) {
        state = state.copyWith(
          status: SubscriptionStatus.loaded,
          subscriptionPlan: subscriptionPlan,
        );
      },
    );
  }

  Future<void> getSubscriptionPlansByShopId({required String shopId}) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = GetSubscriptionPlansByShopIdUsecaseParams(shopId: shopId);
    final result = await _getSubscriptionPlansByShopIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscriptionPlans) {
        state = state.copyWith(
          status: SubscriptionStatus.loaded,
          subscriptionPlans: subscriptionPlans,
        );
      },
    );
  }

  Future<void> updateSubscriptionPlan({
    required String subscriptionPlanId,
    required SubscriptionPlanEntity subscriptionPlanEntity,
  }) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = UpdateSubscriptionPlanUsecaseParams(
      id: subscriptionPlanId,
      subscriptionPlanEntity: subscriptionPlanEntity,
    );
    final result = await _updateSubscriptionPlanUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (subscriptionPlan) {
        state = state.copyWith(
          status: SubscriptionStatus.updated,
          subscriptionPlan: subscriptionPlan,
        );
      },
    );
  }

  Future<void> deleteSubscriptionPlan({
    required String subscriptionPlanId,
  }) async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final params = DeleteSubscriptionPlanUsecaseParams(id: subscriptionPlanId);
    final result = await _deleteSubscriptionPlanUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(status: SubscriptionStatus.deleted);
      },
    );
  }
}
