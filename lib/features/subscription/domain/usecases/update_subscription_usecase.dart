import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

class UpdateSubscriptionUsecaseParams extends Equatable {
  final String id;
  final SubscriptionEntity subscriptionEntity;

  const UpdateSubscriptionUsecaseParams({
    required this.id,
    required this.subscriptionEntity,
  });

  @override
  List<Object?> get props => [id, subscriptionEntity];
}

final updateSubscriptionUsecaseProvider = Provider<UpdateSubscriptionUsecase>((
  ref,
) {
  final subscriptionRepository = ref.read(subscriptionRepositoryProvider);
  return UpdateSubscriptionUsecase(
    subscriptionRepository: subscriptionRepository,
  );
});

class UpdateSubscriptionUsecase
    implements
        UsecaseWithParms<SubscriptionEntity, UpdateSubscriptionUsecaseParams> {
  final ISubscriptionRepository _subscriptionRepository;

  UpdateSubscriptionUsecase({
    required ISubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  @override
  Future<Either<Failure, SubscriptionEntity>> call(
    UpdateSubscriptionUsecaseParams params,
  ) async {
    return await _subscriptionRepository.updateSubscription(
      params.id,
      params.subscriptionEntity,
    );
  }
}
