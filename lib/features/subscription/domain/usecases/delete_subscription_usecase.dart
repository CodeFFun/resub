import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

class DeleteSubscriptionUsecaseParams extends Equatable {
  final String id;

  const DeleteSubscriptionUsecaseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteSubscriptionUsecaseProvider = Provider<DeleteSubscriptionUsecase>((
  ref,
) {
  final subscriptionRepository = ref.read(subscriptionRepositoryProvider);
  return DeleteSubscriptionUsecase(
    subscriptionRepository: subscriptionRepository,
  );
});

class DeleteSubscriptionUsecase
    implements UsecaseWithParms<bool, DeleteSubscriptionUsecaseParams> {
  final ISubscriptionRepository _subscriptionRepository;

  DeleteSubscriptionUsecase({
    required ISubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  @override
  Future<Either<Failure, bool>> call(
    DeleteSubscriptionUsecaseParams params,
  ) async {
    return await _subscriptionRepository.deleteSubscription(params.id);
  }
}
