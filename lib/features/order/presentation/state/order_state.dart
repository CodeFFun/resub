import 'package:equatable/equatable.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';

enum OrderStatus {
  initial,
  loading,
  created,
  updated,
  deleted,
  error,
  loaded,
}

class OrderState extends Equatable {
  final OrderStatus? status;
  final OrderEntity? order;
  final List<OrderEntity>? orders;
  final OrderItemEntity? orderItem;
  final String? errorMessage;

  const OrderState({
    this.status,
    this.order,
    this.orders,
    this.orderItem,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderStatus? status,
    OrderEntity? order,
    List<OrderEntity>? orders,
    OrderItemEntity? orderItem,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      order: order ?? this.order,
      orders: orders ?? this.orders,
      orderItem: orderItem ?? this.orderItem,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, order, orders, orderItem, errorMessage];
}
