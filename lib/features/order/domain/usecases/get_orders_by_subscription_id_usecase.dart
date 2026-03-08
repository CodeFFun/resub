import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

class GetOrdersBySubscriptionIdUsecaseParams extends Equatable {
  final String subscriptionId;

  const GetOrdersBySubscriptionIdUsecaseParams({required this.subscriptionId});

  @override
  List<Object?> get props => [subscriptionId];
}

final getOrdersBySubscriptionIdUsecaseProvider =
    Provider<GetOrdersBySubscriptionIdUsecase>((ref) {
      final orderRepository = ref.read(orderRepositoryProvider);
      return GetOrdersBySubscriptionIdUsecase(orderRepository: orderRepository);
    });

class GetOrdersBySubscriptionIdUsecase
    implements
        UsecaseWithParms<
          List<OrderEntity>,
          GetOrdersBySubscriptionIdUsecaseParams
        > {
  final IOrderRepository _orderRepository;

  GetOrdersBySubscriptionIdUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call(
    GetOrdersBySubscriptionIdUsecaseParams params,
  ) {
    return _orderRepository.getOrdersBySubscriptionId(params.subscriptionId);
  }
}
