import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

class DeleteOrderUsecaseParams extends Equatable {
  final String orderId;

  const DeleteOrderUsecaseParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final deleteOrderUsecaseProvider = Provider<DeleteOrderUsecase>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return DeleteOrderUsecase(orderRepository: orderRepository);
});

class DeleteOrderUsecase
    implements UsecaseWithParms<bool, DeleteOrderUsecaseParams> {
  final IOrderRepository _orderRepository;

  DeleteOrderUsecase({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteOrderUsecaseParams params) {
    return _orderRepository.deleteOrder(params.orderId);
  }
}
