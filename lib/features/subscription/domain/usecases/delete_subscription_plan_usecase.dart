import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_plan_repository.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_plan_repository.dart';

class DeleteSubscriptionPlanUsecaseParams extends Equatable {
  final String id;

  const DeleteSubscriptionPlanUsecaseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteSubscriptionPlanUsecaseProvider =
    Provider<DeleteSubscriptionPlanUsecase>((ref) {
      final subscriptionPlanRepository = ref.read(
        subscriptionPlanRepositoryProvider,
      );
      return DeleteSubscriptionPlanUsecase(
        subscriptionPlanRepository: subscriptionPlanRepository,
      );
    });

class DeleteSubscriptionPlanUsecase
    implements UsecaseWithParms<bool, DeleteSubscriptionPlanUsecaseParams> {
  final ISubscriptionPlanRepository _subscriptionPlanRepository;

  DeleteSubscriptionPlanUsecase({
    required ISubscriptionPlanRepository subscriptionPlanRepository,
  }) : _subscriptionPlanRepository = subscriptionPlanRepository;

  @override
  Future<Either<Failure, bool>> call(
    DeleteSubscriptionPlanUsecaseParams params,
  ) async {
    return await _subscriptionPlanRepository.deleteSubscriptionPlan(params.id);
  }
}
