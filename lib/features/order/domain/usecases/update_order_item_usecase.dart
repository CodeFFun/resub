import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_item_repository.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/domain/repositories/order_item_repository.dart';

class UpdateOrderItemUsecaseParams extends Equatable {
  final String orderItemId;
  final OrderItemEntity orderItemEntity;

  const UpdateOrderItemUsecaseParams({
    required this.orderItemId,
    required this.orderItemEntity,
  });

  @override
  List<Object?> get props => [orderItemId, orderItemEntity];
}

final updateOrderItemUsecaseProvider = Provider<UpdateOrderItemUsecase>((ref) {
  final orderItemRepository = ref.read(orderItemRepositoryProvider);
  return UpdateOrderItemUsecase(orderItemRepository: orderItemRepository);
});

class UpdateOrderItemUsecase
    implements UsecaseWithParms<OrderItemEntity, UpdateOrderItemUsecaseParams> {
  final IOrderItemRepository _orderItemRepository;

  UpdateOrderItemUsecase({required IOrderItemRepository orderItemRepository})
    : _orderItemRepository = orderItemRepository;

  @override
  Future<Either<Failure, OrderItemEntity>> call(
    UpdateOrderItemUsecaseParams params,
  ) {
    return _orderItemRepository.updateOrderItem(
      params.orderItemId,
      params.orderItemEntity,
    );
  }
}
