import 'package:equatable/equatable.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';

class ShopInfo extends Equatable {
  final String? id;
  final String? name;

  const ShopInfo({this.id, this.name});

  ShopInfo copyWith({String? id, String? name}) {
    return ShopInfo(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}

class OrderEntity extends Equatable {
  final String? id;
  final List<OrderItemEntity>? orderItemsId;
  final ShopInfo? shopId;
  final String? deliveryType;
  final DateTime? scheduleFor;
  final String? subscriptionId;
  final String? userId;

  const OrderEntity({
    this.id,
    this.orderItemsId,
    this.shopId,
    this.deliveryType,
    this.scheduleFor,
    this.subscriptionId,
    this.userId,
  });

  OrderEntity copyWith({
    String? id,
    List<OrderItemEntity>? orderItemsId,
    ShopInfo? shopId,
    String? deliveryType,
    DateTime? scheduleFor,
    String? subscriptionId,
    String? userId,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      orderItemsId: orderItemsId ?? this.orderItemsId,
      shopId: shopId ?? this.shopId,
      deliveryType: deliveryType ?? this.deliveryType,
      scheduleFor: scheduleFor ?? this.scheduleFor,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderItemsId,
    shopId,
    deliveryType,
    scheduleFor,
    subscriptionId,
    userId,
  ];
}
