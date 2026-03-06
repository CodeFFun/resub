import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String? provider;
  final String? status;
  final double amount;
  final DateTime? paidAt;
  final List<String>? orderId;
  final String? subscriptionId;
  final String? userId;
  final String? shopId;
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
    this.subscriptionId,
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
    String? subscriptionId,
    String? userId,
    String? shopId,
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
      subscriptionId: subscriptionId ?? this.subscriptionId,
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
    subscriptionId,
    userId,
    shopId,
    orderItemsId,
    createdAt,
    updatedAt,
  ];
}
