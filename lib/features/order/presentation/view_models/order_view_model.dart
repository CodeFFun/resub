import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/domain/usecases/create_order_item_usecase.dart';
import 'package:resub/features/order/domain/usecases/create_order_usecase.dart';
import 'package:resub/features/order/domain/usecases/delete_order_item_usecase.dart';
import 'package:resub/features/order/domain/usecases/delete_order_usecase.dart';
import 'package:resub/features/order/domain/usecases/get_order_by_id_usecase.dart';
import 'package:resub/features/order/domain/usecases/get_order_item_by_id_usecase.dart';
import 'package:resub/features/order/domain/usecases/get_orders_by_shop_id_usecase.dart';
import 'package:resub/features/order/domain/usecases/get_orders_by_subscription_id_usecase.dart';
import 'package:resub/features/order/domain/usecases/get_orders_by_user_id_usecase.dart';
import 'package:resub/features/order/domain/usecases/update_order_item_usecase.dart';
import 'package:resub/features/order/domain/usecases/update_order_usecase.dart';
import 'package:resub/features/order/presentation/state/order_state.dart';

final orderViewModelProvider = NotifierProvider<OrderViewModel, OrderState>(
  () => OrderViewModel(),
);

class OrderViewModel extends Notifier<OrderState> {
  late final CreateOrderUsecase _createOrderUsecase;
  late final DeleteOrderUsecase _deleteOrderUsecase;
  late final GetOrderByIdUsecase _getOrderByIdUsecase;
  late final GetOrdersByUserIdUsecase _getOrdersByUserIdUsecase;
  late final GetOrdersByShopIdUsecase _getOrdersByShopIdUsecase;
  late final GetOrdersBySubscriptionIdUsecase _getOrdersBySubscriptionIdUsecase;
  late final UpdateOrderUsecase _updateOrderUsecase;
  late final CreateOrderItemUsecase _createOrderItemUsecase;
  late final DeleteOrderItemUsecase _deleteOrderItemUsecase;
  late final GetOrderItemByIdUsecase _getOrderItemByIdUsecase;
  late final UpdateOrderItemUsecase _updateOrderItemUsecase;

  @override
  build() {
    _createOrderUsecase = ref.read(createOrderUsecaseProvider);
    _deleteOrderUsecase = ref.read(deleteOrderUsecaseProvider);
    _getOrderByIdUsecase = ref.read(getOrderByIdUsecaseProvider);
    _getOrdersByUserIdUsecase = ref.read(getOrdersByUserIdUsecaseProvider);
    _getOrdersByShopIdUsecase = ref.read(getOrdersByShopIdUsecaseProvider);
    _getOrdersBySubscriptionIdUsecase = ref.read(
      getOrdersBySubscriptionIdUsecaseProvider,
    );
    _updateOrderUsecase = ref.read(updateOrderUsecaseProvider);
    _createOrderItemUsecase = ref.read(createOrderItemUsecaseProvider);
    _deleteOrderItemUsecase = ref.read(deleteOrderItemUsecaseProvider);
    _getOrderItemByIdUsecase = ref.read(getOrderItemByIdUsecaseProvider);
    _updateOrderItemUsecase = ref.read(updateOrderItemUsecaseProvider);
    return const OrderState();
  }

  Future<void> createOrder({
    required String shopId,
    required OrderEntity orderEntity,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = CreateOrderUsecaseParams(
      shopId: shopId,
      orderEntity: orderEntity,
    );
    final result = await _createOrderUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (order) {
        state = state.copyWith(status: OrderStatus.created, order: order);
      },
    );
  }

  Future<void> getOrderById({required String orderId}) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = GetOrderByIdUsecaseParams(orderId: orderId);
    final result = await _getOrderByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (order) {
        state = state.copyWith(status: OrderStatus.loaded, order: order);
      },
    );
  }

  Future<void> getOrdersByUserId() async {
    state = state.copyWith(status: OrderStatus.loading);
    final result = await _getOrdersByUserIdUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(status: OrderStatus.loaded, orders: orders);
      },
    );
  }

  Future<void> getOrdersByShopId({required String shopId}) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = GetOrdersByShopIdUsecaseParams(shopId: shopId);
    final result = await _getOrdersByShopIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(status: OrderStatus.loaded, orders: orders);
      },
    );
  }

  Future<void> getOrdersBySubscriptionId({
    required String subscriptionId,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = GetOrdersBySubscriptionIdUsecaseParams(
      subscriptionId: subscriptionId,
    );
    final result = await _getOrdersBySubscriptionIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(status: OrderStatus.loaded, orders: orders);
      },
    );
  }

  Future<void> updateOrder({
    required String orderId,
    required OrderEntity orderEntity,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = UpdateOrderUsecaseParams(
      orderId: orderId,
      orderEntity: orderEntity,
    );
    final result = await _updateOrderUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (order) {
        state = state.copyWith(status: OrderStatus.updated, order: order);
      },
    );
  }

  Future<void> deleteOrder({required String orderId}) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = DeleteOrderUsecaseParams(orderId: orderId);
    final result = await _deleteOrderUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          state = state.copyWith(status: OrderStatus.deleted);
        } else {
          state = state.copyWith(
            status: OrderStatus.error,
            errorMessage: 'Order deletion failed',
          );
        }
      },
    );
  }

  // Order Item Methods
  Future<void> createOrderItem({
    required OrderItemEntity orderItemEntity,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = CreateOrderItemUsecaseParams(
      orderItemEntity: orderItemEntity,
    );
    final result = await _createOrderItemUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (orderItem) {
        state = state.copyWith(
          status: OrderStatus.created,
          orderItem: orderItem,
        );
      },
    );
  }

  Future<void> getOrderItemById({required String orderItemId}) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = GetOrderItemByIdUsecaseParams(orderItemId: orderItemId);
    final result = await _getOrderItemByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (orderItem) {
        state = state.copyWith(
          status: OrderStatus.loaded,
          orderItem: orderItem,
        );
      },
    );
  }

  Future<void> updateOrderItem({
    required String orderItemId,
    required OrderItemEntity orderItemEntity,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = UpdateOrderItemUsecaseParams(
      orderItemId: orderItemId,
      orderItemEntity: orderItemEntity,
    );
    final result = await _updateOrderItemUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (orderItem) {
        state = state.copyWith(
          status: OrderStatus.updated,
          orderItem: orderItem,
        );
      },
    );
  }

  Future<void> deleteOrderItem({required String orderItemId}) async {
    state = state.copyWith(status: OrderStatus.loading);
    final params = DeleteOrderItemUsecaseParams(orderItemId: orderItemId);
    final result = await _deleteOrderItemUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          state = state.copyWith(status: OrderStatus.deleted);
        } else {
          state = state.copyWith(
            status: OrderStatus.error,
            errorMessage: 'Order item deletion failed',
          );
        }
      },
    );
  }
}
