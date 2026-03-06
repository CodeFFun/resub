import 'package:equatable/equatable.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String? provider;
  final String? status;
  final double amount;
  final DateTime? paidAt;
  final List<String>? orderId;
  final List<OrderEntity>? orders;
  final String? subscriptionId;
  final SubscriptionEntity? subscription;
  final UserEntity? userId;
  final ShopEntity? shopId;
  final List<String>? orderItemsId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PaymentEntity({
    this.id,
    this.provider,
    this.status,
    required this.amount,
    this.paidAt,
    this.orderId,
    this.orders,
    this.subscriptionId,
    this.subscription,
    this.userId,
    this.shopId,
    this.orderItemsId,
    this.createdAt,
    this.updatedAt,
  });

  PaymentEntity copyWith({
    String? id,
    String? provider,
    String? status,
    double? amount,
    DateTime? paidAt,
    List<String>? orderId,
    List<OrderEntity>? orders,
    String? subscriptionId,
    SubscriptionEntity? subscription,
    UserEntity? userId,
    ShopEntity? shopId,
    List<String>? orderItemsId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentEntity(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      paidAt: paidAt ?? this.paidAt,
      orderId: orderId ?? this.orderId,
      orders: orders ?? this.orders,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      subscription: subscription ?? this.subscription,
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      orderItemsId: orderItemsId ?? this.orderItemsId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    provider,
    status,
    amount,
    paidAt,
    orderId,
    orders,
    subscriptionId,
    subscription,
    userId,
    shopId,
    orderItemsId,
    createdAt,
    updatedAt,
  ];
}
