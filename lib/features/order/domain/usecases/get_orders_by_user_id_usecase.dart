import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

final getOrdersByUserIdUsecaseProvider = Provider<GetOrdersByUserIdUsecase>((
  ref,
) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return GetOrdersByUserIdUsecase(orderRepository: orderRepository);
});

class GetOrdersByUserIdUsecase
    implements UsecaseWithoutParms<List<OrderEntity>> {
  final IOrderRepository _orderRepository;

  GetOrdersByUserIdUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call() {
    return _orderRepository.getOrdersByUserId();
  }
}
