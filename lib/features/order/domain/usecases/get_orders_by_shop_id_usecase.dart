import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

class GetOrdersByShopIdUsecaseParams extends Equatable {
  final String shopId;

  const GetOrdersByShopIdUsecaseParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getOrdersByShopIdUsecaseProvider = Provider<GetOrdersByShopIdUsecase>((
  ref,
) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return GetOrdersByShopIdUsecase(orderRepository: orderRepository);
});

class GetOrdersByShopIdUsecase
    implements
        UsecaseWithParms<List<OrderEntity>, GetOrdersByShopIdUsecaseParams> {
  final IOrderRepository _orderRepository;

  GetOrdersByShopIdUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call(
    GetOrdersByShopIdUsecaseParams params,
  ) {
    return _orderRepository.getOrdersByShopId(params.shopId);
  }
}
