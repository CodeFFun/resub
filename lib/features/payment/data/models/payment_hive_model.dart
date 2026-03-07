import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';

part 'payment_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.paymentsTypeId)
class PaymentHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? provider;

  @HiveField(2)
  final String? status;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime? paidAt;

  @HiveField(5)
  final List<String>? orderId;

  @HiveField(6)
  final String? subscriptionId;

  @HiveField(7)
  final String? userId;

  @HiveField(8)
  final String? shopId;

  @HiveField(9)
  final List<String>? orderItemsId;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  PaymentHiveModel({
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

  // From entity
  factory PaymentHiveModel.fromEntity(PaymentEntity entity) {
    return PaymentHiveModel(
      id: entity.id,
      provider: entity.provider,
      status: entity.status,
      amount: entity.amount,
      paidAt: entity.paidAt,
      orderId: entity.orderId,
      subscriptionId: entity.subscriptionId,
      userId: entity.userId?.userId,
      shopId: entity.shopId?.id,
      orderItemsId: entity.orderItemsId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To entity
  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      provider: provider,
      status: status,
      amount: amount,
      paidAt: paidAt,
      orderId: orderId,
      orders: null, // Orders should be fetched separately
      subscriptionId: subscriptionId,
      subscription: null, // Subscription should be fetched separately
      userId: null, // User should be fetched separately
      shopId: null, // Shop should be fetched separately
      orderItemsId: orderItemsId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
