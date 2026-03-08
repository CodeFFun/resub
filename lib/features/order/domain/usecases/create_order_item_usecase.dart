import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_item_repository.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/domain/repositories/order_item_repository.dart';

class CreateOrderItemUsecaseParams extends Equatable {
  final OrderItemEntity orderItemEntity;

  const CreateOrderItemUsecaseParams({required this.orderItemEntity});

  @override
  List<Object?> get props => [orderItemEntity];
}

final createOrderItemUsecaseProvider = Provider<CreateOrderItemUsecase>((ref) {
  final orderItemRepository = ref.read(orderItemRepositoryProvider);
  return CreateOrderItemUsecase(orderItemRepository: orderItemRepository);
});

class CreateOrderItemUsecase
    implements UsecaseWithParms<OrderItemEntity, CreateOrderItemUsecaseParams> {
  final IOrderItemRepository _orderItemRepository;

  CreateOrderItemUsecase({required IOrderItemRepository orderItemRepository})
    : _orderItemRepository = orderItemRepository;

  @override
  Future<Either<Failure, OrderItemEntity>> call(
    CreateOrderItemUsecaseParams params,
  ) {
    return _orderItemRepository.createOrderItem(params.orderItemEntity);
  }
}
