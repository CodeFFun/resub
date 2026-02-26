import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_plan_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_plan_repository.dart';

class CreateSubscriptionPlanUsecaseParams extends Equatable {
  final SubscriptionPlanEntity subscriptionPlanEntity;

  const CreateSubscriptionPlanUsecaseParams({
    required this.subscriptionPlanEntity,
  });

  @override
  List<Object?> get props => [subscriptionPlanEntity];
}

final createSubscriptionPlanUsecaseProvider =
    Provider<CreateSubscriptionPlanUsecase>((ref) {
      final subscriptionPlanRepository = ref.read(
        subscriptionPlanRepositoryProvider,
      );
      return CreateSubscriptionPlanUsecase(
        subscriptionPlanRepository: subscriptionPlanRepository,
      );
    });

class CreateSubscriptionPlanUsecase
    implements
        UsecaseWithParms<
          SubscriptionPlanEntity,
          CreateSubscriptionPlanUsecaseParams
        > {
  final ISubscriptionPlanRepository _subscriptionPlanRepository;

  CreateSubscriptionPlanUsecase({
    required ISubscriptionPlanRepository subscriptionPlanRepository,
  }) : _subscriptionPlanRepository = subscriptionPlanRepository;

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> call(
    CreateSubscriptionPlanUsecaseParams params,
  ) async {
    return await _subscriptionPlanRepository.createSubscriptionPlan(
      params.subscriptionPlanEntity,
    );
  }
}
