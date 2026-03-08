import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_plan_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_plan_repository.dart';

class GetSubscriptionPlansByShopIdUsecaseParams extends Equatable {
  final String shopId;

  const GetSubscriptionPlansByShopIdUsecaseParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getSubscriptionPlansByShopIdUsecaseProvider =
    Provider<GetSubscriptionPlansByShopIdUsecase>((ref) {
      final subscriptionPlanRepository = ref.read(
        subscriptionPlanRepositoryProvider,
      );
      return GetSubscriptionPlansByShopIdUsecase(
        subscriptionPlanRepository: subscriptionPlanRepository,
      );
    });

class GetSubscriptionPlansByShopIdUsecase
    implements
        UsecaseWithParms<
          List<SubscriptionPlanEntity>,
          GetSubscriptionPlansByShopIdUsecaseParams
        > {
  final ISubscriptionPlanRepository _subscriptionPlanRepository;

  GetSubscriptionPlansByShopIdUsecase({
    required ISubscriptionPlanRepository subscriptionPlanRepository,
  }) : _subscriptionPlanRepository = subscriptionPlanRepository;

  @override
  Future<Either<Failure, List<SubscriptionPlanEntity>>> call(
    GetSubscriptionPlansByShopIdUsecaseParams params,
  ) async {
    return await _subscriptionPlanRepository.getSubscriptionPlansByShopId(
      params.shopId,
    );
  }
}
