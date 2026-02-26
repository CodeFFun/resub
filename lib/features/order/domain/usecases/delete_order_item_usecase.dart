import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_item_repository.dart';
import 'package:resub/features/order/domain/repositories/order_item_repository.dart';

class DeleteOrderItemUsecaseParams extends Equatable {
  final String orderItemId;

  const DeleteOrderItemUsecaseParams({required this.orderItemId});

  @override
  List<Object?> get props => [orderItemId];
}

final deleteOrderItemUsecaseProvider = Provider<DeleteOrderItemUsecase>((ref) {
  final orderItemRepository = ref.read(orderItemRepositoryProvider);
  return DeleteOrderItemUsecase(orderItemRepository: orderItemRepository);
});

class DeleteOrderItemUsecase
    implements UsecaseWithParms<bool, DeleteOrderItemUsecaseParams> {
  final IOrderItemRepository _orderItemRepository;

  DeleteOrderItemUsecase({required IOrderItemRepository orderItemRepository})
    : _orderItemRepository = orderItemRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteOrderItemUsecaseParams params) {
    return _orderItemRepository.deleteOrderItem(params.orderItemId);
  }
}
