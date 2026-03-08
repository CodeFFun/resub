import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/order/data/repositories/order_item_repository.dart';
import 'package:resub/features/order/data/repositories/order_repository.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/domain/repositories/order_item_repository.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';
import 'package:resub/features/order/presentation/state/order_state.dart';
import 'package:resub/features/order/presentation/view_models/order_view_model.dart';

class _FakeOrderRepository implements IOrderRepository {
  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    return const Right(OrderEntity(id: 'o1', deliveryType: 'pickup'));
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    String shopId,
    OrderEntity orderEntity,
  ) async {
    return Right(orderEntity.copyWith(id: 'created-order'));
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByShopId(
    String shopId,
  ) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersBySubscriptionId(
    String subscriptionId,
  ) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrder(
    String id,
    OrderEntity orderEntity,
  ) async {
    return Right(orderEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteOrder(String id) async {
    return const Right(true);
  }
}

class _FakeOrderItemRepository implements IOrderItemRepository {
  @override
  Future<Either<Failure, OrderItemEntity>> createOrderItem(
    OrderItemEntity orderItemEntity,
  ) async {
    return Right(orderItemEntity.copyWith(id: 'oi-created'));
  }

  @override
  Future<Either<Failure, OrderItemEntity>> getOrderItemById(String id) async {
    return const Right(OrderItemEntity(id: 'oi-1'));
  }

  @override
  Future<Either<Failure, OrderItemEntity>> updateOrderItem(
    String id,
    OrderItemEntity orderItemEntity,
  ) async {
    return Right(orderItemEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteOrderItem(String id) async {
    return const Right(true);
  }
}

void main() {
  late ProviderContainer container;
  late OrderViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        orderRepositoryProvider.overrideWithValue(_FakeOrderRepository()),
        orderItemRepositoryProvider.overrideWithValue(
          _FakeOrderItemRepository(),
        ),
      ],
    );
    viewModel = container.read(orderViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getOrderById sets loaded state with order', () async {
      await viewModel.getOrderById(orderId: 'o1');

      final state = container.read(orderViewModelProvider);
      expect(state.status, OrderStatus.loaded);
      expect(state.order?.id, 'o1');
    });
  });

  group('other methods', () {
    test('createOrder sets created state', () async {
      await viewModel.createOrder(
        shopId: 'shop-1',
        orderEntity: const OrderEntity(),
      );

      final state = container.read(orderViewModelProvider);
      expect(state.status, OrderStatus.created);
      expect(state.order?.id, 'created-order');
    });
  });
}
