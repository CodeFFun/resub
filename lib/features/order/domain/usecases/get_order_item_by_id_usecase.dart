import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_item_repository.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/domain/repositories/order_item_repository.dart';

class GetOrderItemByIdUsecaseParams extends Equatable {
  final String orderItemId;

  const GetOrderItemByIdUsecaseParams({required this.orderItemId});

  @override
  List<Object?> get props => [orderItemId];
}

final getOrderItemByIdUsecaseProvider = Provider<GetOrderItemByIdUsecase>((
  ref,
) {
  final orderItemRepository = ref.read(orderItemRepositoryProvider);
  return GetOrderItemByIdUsecase(orderItemRepository: orderItemRepository);
});

class GetOrderItemByIdUsecase
    implements
        UsecaseWithParms<OrderItemEntity, GetOrderItemByIdUsecaseParams> {
  final IOrderItemRepository _orderItemRepository;

  GetOrderItemByIdUsecase({required IOrderItemRepository orderItemRepository})
    : _orderItemRepository = orderItemRepository;

  @override
  Future<Either<Failure, OrderItemEntity>> call(
    GetOrderItemByIdUsecaseParams params,
  ) {
    return _orderItemRepository.getOrderItemById(params.orderItemId);
  }
}
