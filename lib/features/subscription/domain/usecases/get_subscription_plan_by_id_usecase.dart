import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_plan_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_plan_repository.dart';

class GetSubscriptionPlanByIdUsecaseParams extends Equatable {
  final String id;

  const GetSubscriptionPlanByIdUsecaseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getSubscriptionPlanByIdUsecaseProvider =
    Provider<GetSubscriptionPlanByIdUsecase>((ref) {
      final subscriptionPlanRepository = ref.read(
        subscriptionPlanRepositoryProvider,
      );
      return GetSubscriptionPlanByIdUsecase(
        subscriptionPlanRepository: subscriptionPlanRepository,
      );
    });

class GetSubscriptionPlanByIdUsecase
    implements
        UsecaseWithParms<
          SubscriptionPlanEntity,
          GetSubscriptionPlanByIdUsecaseParams
        > {
  final ISubscriptionPlanRepository _subscriptionPlanRepository;

  GetSubscriptionPlanByIdUsecase({
    required ISubscriptionPlanRepository subscriptionPlanRepository,
  }) : _subscriptionPlanRepository = subscriptionPlanRepository;

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> call(
    GetSubscriptionPlanByIdUsecaseParams params,
  ) async {
    return await _subscriptionPlanRepository.getSubscriptionPlanById(params.id);
  }
}
