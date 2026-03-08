import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

class UpdateOrderUsecaseParams extends Equatable {
  final String orderId;
  final OrderEntity orderEntity;

  const UpdateOrderUsecaseParams({
    required this.orderId,
    required this.orderEntity,
  });

  @override
  List<Object?> get props => [orderId, orderEntity];
}

final updateOrderUsecaseProvider = Provider<UpdateOrderUsecase>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return UpdateOrderUsecase(orderRepository: orderRepository);
});

class UpdateOrderUsecase
    implements UsecaseWithParms<OrderEntity, UpdateOrderUsecaseParams> {
  final IOrderRepository _orderRepository;

  UpdateOrderUsecase({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(
    UpdateOrderUsecaseParams params,
  ) {
    return _orderRepository.updateOrder(
      params.orderId,
      params.orderEntity,
    );
  }
}
