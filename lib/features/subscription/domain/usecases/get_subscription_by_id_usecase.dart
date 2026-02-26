import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

class GetSubscriptionByIdUsecaseParams extends Equatable {
  final String id;

  const GetSubscriptionByIdUsecaseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getSubscriptionByIdUsecaseProvider = Provider<GetSubscriptionByIdUsecase>(
  (ref) {
    final subscriptionRepository = ref.read(subscriptionRepositoryProvider);
    return GetSubscriptionByIdUsecase(
      subscriptionRepository: subscriptionRepository,
    );
  },
);

class GetSubscriptionByIdUsecase
    implements
        UsecaseWithParms<SubscriptionEntity, GetSubscriptionByIdUsecaseParams> {
  final ISubscriptionRepository _subscriptionRepository;

  GetSubscriptionByIdUsecase({
    required ISubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  @override
  Future<Either<Failure, SubscriptionEntity>> call(
    GetSubscriptionByIdUsecaseParams params,
  ) async {
    return await _subscriptionRepository.getSubscriptionById(params.id);
  }
}
