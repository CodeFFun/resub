import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/order/data/models/order_hive_model.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/shop/data/models/shop_hive_model.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/subscription/data/models/subscription_hive_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

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

  // Non-persisted fields for populated relationships.
  List<OrderHiveModel>? _orders;
  SubscriptionHiveModel? _subscription;
  UserHiveModel? _user;
  ShopHiveModel? _shop;

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
    List<OrderHiveModel>? orders,
    SubscriptionHiveModel? subscription,
    UserHiveModel? user,
    ShopHiveModel? shop,
  }) : _orders = orders,
       _subscription = subscription,
       _user = user,
       _shop = shop;

  // Getters for populated relationships.
  List<OrderHiveModel>? get orders => _orders;
  SubscriptionHiveModel? get subscription => _subscription;
  UserHiveModel? get user => _user;
  ShopHiveModel? get shop => _shop;

  // Setters for populated relationships.
  void setOrders(List<OrderHiveModel>? orders) => _orders = orders;
  void setSubscription(SubscriptionHiveModel? subscription) {
    _subscription = subscription;
  }

  void setUser(UserHiveModel? user) => _user = user;
  void setShop(ShopHiveModel? shop) => _shop = shop;

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
    final resolvedOrders = _orders != null
        ? _orders!.map((order) => order.toEntity()).toList()
        : (orderId != null && orderId!.isNotEmpty)
        ? orderId!.map((id) => OrderEntity(id: id)).toList()
        : null;

    final resolvedSubscription =
        _subscription?.toEntity() ??
        (subscriptionId != null
            ? SubscriptionEntity(id: subscriptionId)
            : null);

    final resolvedUser =
        _user?.toEntity() ??
        (userId != null ? UserEntity(userId: userId) : null);

    final resolvedShop =
        _shop?.toEntity() ?? (shopId != null ? ShopEntity(id: shopId) : null);

    return PaymentEntity(
      id: id,
      provider: provider,
      status: status,
      amount: amount,
      paidAt: paidAt,
      orderId: orderId,
      orders: resolvedOrders,
      subscriptionId: subscriptionId,
      subscription: resolvedSubscription,
      userId: resolvedUser,
      shopId: resolvedShop,
      orderItemsId: orderItemsId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
