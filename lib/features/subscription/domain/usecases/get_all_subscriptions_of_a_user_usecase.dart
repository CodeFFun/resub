import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/subscription/data/repositories/subscription_repository.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

final getAllSubscriptionsOfAUserUsecaseProvider =
    Provider<GetAllSubscriptionsOfAUserUsecase>((ref) {
      final subscriptionRepository = ref.read(subscriptionRepositoryProvider);
      return GetAllSubscriptionsOfAUserUsecase(
        subscriptionRepository: subscriptionRepository,
      );
    });

class GetAllSubscriptionsOfAUserUsecase
    implements UsecaseWithoutParms<List<SubscriptionEntity>> {
  final ISubscriptionRepository _subscriptionRepository;

  GetAllSubscriptionsOfAUserUsecase({
    required ISubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> call() async {
    return await _subscriptionRepository.getAllSubscriptionsOfAUser();
  }
}
