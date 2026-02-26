import 'package:equatable/equatable.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';

enum SubscriptionStatus {
  initial,
  loading,
  created,
  updated,
  deleted,
  error,
  loaded,
}

class SubscriptionState extends Equatable {
  final SubscriptionStatus? status;
  final SubscriptionEntity? subscription;
  final List<SubscriptionEntity>? subscriptions;
  final SubscriptionPlanEntity? subscriptionPlan;
  final List<SubscriptionPlanEntity>? subscriptionPlans;
  final String? errorMessage;

  const SubscriptionState({
    this.status,
    this.subscription,
    this.subscriptions,
    this.subscriptionPlan,
    this.subscriptionPlans,
    this.errorMessage,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    SubscriptionEntity? subscription,
    List<SubscriptionEntity>? subscriptions,
    SubscriptionPlanEntity? subscriptionPlan,
    List<SubscriptionPlanEntity>? subscriptionPlans,
    String? errorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      subscriptions: subscriptions ?? this.subscriptions,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionPlans: subscriptionPlans ?? this.subscriptionPlans,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    subscription,
    subscriptions,
    subscriptionPlan,
    subscriptionPlans,
    errorMessage,
  ];
}
