import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

class CreateOrderUsecaseParams extends Equatable {
  final String shopId;
  final OrderEntity orderEntity;

  const CreateOrderUsecaseParams({
    required this.shopId,
    required this.orderEntity,
  });

  @override
  List<Object?> get props => [orderEntity];
}

final createOrderUsecaseProvider = Provider<CreateOrderUsecase>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return CreateOrderUsecase(orderRepository: orderRepository);
});

class CreateOrderUsecase
    implements UsecaseWithParms<OrderEntity, CreateOrderUsecaseParams> {
  final IOrderRepository _orderRepository;

  CreateOrderUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderUsecaseParams params) {
    return _orderRepository.createOrder(params.shopId, params.orderEntity);
  }
}
