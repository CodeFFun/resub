import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

class CreateSubscriptionUsecaseParams extends Equatable {
  final String shopId;
  final SubscriptionEntity subscriptionEntity;

  const CreateSubscriptionUsecaseParams({
    required this.shopId,
    required this.subscriptionEntity,
  });

  @override
  List<Object?> get props => [shopId, subscriptionEntity];
}

final createSubscriptionUsecaseProvider = Provider<CreateSubscriptionUsecase>((
  ref,
) {
  final subscriptionRepository = ref.read(subscriptionRepositoryProvider);
  return CreateSubscriptionUsecase(
    subscriptionRepository: subscriptionRepository,
  );
});

class CreateSubscriptionUsecase
    implements
        UsecaseWithParms<SubscriptionEntity, CreateSubscriptionUsecaseParams> {
  final ISubscriptionRepository _subscriptionRepository;

  CreateSubscriptionUsecase({
    required ISubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  @override
  Future<Either<Failure, SubscriptionEntity>> call(
    CreateSubscriptionUsecaseParams params,
  ) async {
    return await _subscriptionRepository.createSubscription(
      params.shopId,
      params.subscriptionEntity,
    );
  }
}
