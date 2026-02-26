import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_plan_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_plan_repository.dart';

class UpdateSubscriptionPlanUsecaseParams extends Equatable {
  final String id;
  final SubscriptionPlanEntity subscriptionPlanEntity;

  const UpdateSubscriptionPlanUsecaseParams({
    required this.id,
    required this.subscriptionPlanEntity,
  });

  @override
  List<Object?> get props => [id, subscriptionPlanEntity];
}

final updateSubscriptionPlanUsecaseProvider =
    Provider<UpdateSubscriptionPlanUsecase>((ref) {
      final subscriptionPlanRepository = ref.read(
        subscriptionPlanRepositoryProvider,
      );
      return UpdateSubscriptionPlanUsecase(
        subscriptionPlanRepository: subscriptionPlanRepository,
      );
    });

class UpdateSubscriptionPlanUsecase
    implements
        UsecaseWithParms<
          SubscriptionPlanEntity,
          UpdateSubscriptionPlanUsecaseParams
        > {
  final ISubscriptionPlanRepository _subscriptionPlanRepository;

  UpdateSubscriptionPlanUsecase({
    required ISubscriptionPlanRepository subscriptionPlanRepository,
  }) : _subscriptionPlanRepository = subscriptionPlanRepository;

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> call(
    UpdateSubscriptionPlanUsecaseParams params,
  ) async {
    return await _subscriptionPlanRepository.updateSubscriptionPlan(
      params.id,
      params.subscriptionPlanEntity,
    );
  }
}
