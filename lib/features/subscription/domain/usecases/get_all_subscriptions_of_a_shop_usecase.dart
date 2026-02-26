import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

class GetAllSubscriptionsOfAShopUsecaseParams extends Equatable {
  final String shopId;

  const GetAllSubscriptionsOfAShopUsecaseParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getAllSubscriptionsOfAShopUsecaseProvider =
    Provider<GetAllSubscriptionsOfAShopUsecase>((ref) {
      final subscriptionRepository = ref.read(subscriptionRepositoryProvider);
      return GetAllSubscriptionsOfAShopUsecase(
        subscriptionRepository: subscriptionRepository,
      );
    });

class GetAllSubscriptionsOfAShopUsecase
    implements
        UsecaseWithParms<
          List<SubscriptionEntity>,
          GetAllSubscriptionsOfAShopUsecaseParams
        > {
  final ISubscriptionRepository _subscriptionRepository;

  GetAllSubscriptionsOfAShopUsecase({
    required ISubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> call(
    GetAllSubscriptionsOfAShopUsecaseParams params,
  ) async {
    return await _subscriptionRepository.getAllSubscriptionsOfAShop(
      params.shopId,
    );
  }
}
