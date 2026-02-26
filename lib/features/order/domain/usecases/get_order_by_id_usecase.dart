import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

class GetOrderByIdUsecaseParams extends Equatable {
  final String orderId;

  const GetOrderByIdUsecaseParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final getOrderByIdUsecaseProvider = Provider<GetOrderByIdUsecase>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return GetOrderByIdUsecase(orderRepository: orderRepository);
});

class GetOrderByIdUsecase
    implements UsecaseWithParms<OrderEntity, GetOrderByIdUsecaseParams> {
  final IOrderRepository _orderRepository;

  GetOrderByIdUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(GetOrderByIdUsecaseParams params) {
    return _orderRepository.getOrderById(params.orderId);
  }
}
