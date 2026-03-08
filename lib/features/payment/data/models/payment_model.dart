import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/order/data/models/order_model.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/shop/data/models/shop_model.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/subscription/data/models/subscription_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/user/data/models/user_api_model.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class PaymentApiModel {
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

  /// Raw populated objects from API response (not in entity)
  final dynamic orderData; // Can be OrderModel populated object
  final dynamic userData; // Can be UserModel populated object
  final dynamic subscriptionData; // Can be SubscriptionModel populated object
  final dynamic shopData; // Can be ShopModel populated object

  PaymentApiModel({
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
    this.orderData,
    this.userData,
    this.subscriptionData,
    this.shopData,
  });

  /// Extracts ID from either a String ID or a populated object
  static String? _extractId(dynamic value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) return value['_id'] as String?;
    return null;
  }

  static UserEntity? _extractUserEntity(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return UserEntity(userId: value);
    }
    if (value is Map<String, dynamic>) {
      return UserApiModel.fromJson(value).toEntity();
    }
    return null;
  }

  static ShopEntity? _extractShopEntity(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return ShopEntity(id: value);
    }
    if (value is Map<String, dynamic>) {
      return ShopApiModel.fromJson(value).toEntity();
    }
    return null;
  }

  static SubscriptionEntity? _extractSubscriptionEntity(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return SubscriptionEntity(id: value);
    }
    if (value is Map<String, dynamic>) {
      return SubscriptionApiModel.fromJson(value).toEntity();
    }
    return null;
  }

  static List<OrderEntity>? _extractOrders(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      final orders = <OrderEntity>[];
      for (final item in value) {
        if (item is Map<String, dynamic>) {
          orders.add(OrderApiModel.fromJson(item).toEntity());
        } else if (item is String) {
          orders.add(OrderEntity(id: item));
        }
      }
      return orders;
    }
    if (value is Map<String, dynamic>) {
      return [OrderApiModel.fromJson(value).toEntity()];
    }
    if (value is String) {
      return [OrderEntity(id: value)];
    }
    return null;
  }

  static dynamic _extractFromOrderData(dynamic orderValue, String key) {
    if (orderValue is Map<String, dynamic>) {
      return orderValue[key];
    }

    if (orderValue is List) {
      for (final order in orderValue) {
        if (order is Map<String, dynamic> && order[key] != null) {
          return order[key];
        }
      }
    }

    return null;
  }

  /// Extracts list of IDs from either a list of String IDs or populated objects
  static List<String>? _extractIdList(dynamic value) {
    if (value == null) return null;
    if (value is List<String>) return value;
    if (value is List) {
      return value
          .map(
            (item) => item is String ? item : (item as Map?)?['_id'] as String?,
          )
          .whereType<String>()
          .toList();
    }
    return null;
  }

  factory PaymentApiModel.fromJson(Map<String, dynamic> json) {
    final orderIdValue = json['orderId'];
    final userIdValue = json['userId'];
    final subscriptionIdValue = json['subscriptionId'];
    final shopIdValue = json['shopId'];
    final orderItemsIdValue = json['orderItemsId'];

    final resolvedUser =
        _extractUserEntity(userIdValue) ??
        _extractUserEntity(_extractFromOrderData(orderIdValue, 'userId'));
    final resolvedShop =
        _extractShopEntity(shopIdValue) ??
        _extractShopEntity(_extractFromOrderData(orderIdValue, 'shopId'));
    final resolvedSubscription =
        _extractSubscriptionEntity(subscriptionIdValue) ??
        _extractSubscriptionEntity(
          _extractFromOrderData(orderIdValue, 'subscriptionId'),
        );
    final resolvedSubscriptionId =
        _extractId(subscriptionIdValue) ??
        _extractId(_extractFromOrderData(orderIdValue, 'subscriptionId'));

    return PaymentApiModel(
      id: json['_id'] as String?,
      provider: json['provider'] as String? ?? 'esewa',
      status: json['status'] as String? ?? 'completed',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      orderId: _extractIdList(orderIdValue),
      orders: _extractOrders(orderIdValue),
      subscriptionId: resolvedSubscriptionId,
      subscription: resolvedSubscription,
      userId: resolvedUser,
      shopId: resolvedShop,
      orderItemsId: _extractIdList(orderItemsIdValue),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      // Store raw populated data
      orderData: orderIdValue is Map || orderIdValue is List
          ? orderIdValue
          : null,
      userData: userIdValue is Map ? userIdValue : null,
      subscriptionData: subscriptionIdValue is Map ? subscriptionIdValue : null,
      shopData: shopIdValue is Map ? shopIdValue : null,
    );
  }

  /// Send to backend - only amount and orderId
  /// When creating/updating, we only send these minimal fields
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['amount'] = amount;
    final resolvedOrderIds =
        orderId ??
        orders?.map((order) => order.id).whereType<String>().toList();
    if (resolvedOrderIds != null && resolvedOrderIds.isNotEmpty) {
      json['orderId'] = resolvedOrderIds;
    }
    if (provider != null) json['provider'] = provider;
    if (status != null) json['status'] = status;
    return json;
  }

  /// For local storage or full serialization
  Map<String, dynamic> toFullJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (provider != null) json['provider'] = provider;
    if (status != null) json['status'] = status;
    json['amount'] = amount;
    if (paidAt != null) json['paid_at'] = paidAt?.toIso8601String();
    final resolvedOrderIds =
        orderId ??
        orders?.map((order) => order.id).whereType<String>().toList();
    if (resolvedOrderIds != null && resolvedOrderIds.isNotEmpty) {
      json['orderId'] = resolvedOrderIds;
    }
    if (subscriptionId != null) json['subscriptionId'] = subscriptionId;
    if (userId?.userId != null) json['userId'] = userId?.userId;
    if (shopId?.id != null) json['shopId'] = shopId?.id;
    if (orderItemsId != null && orderItemsId!.isNotEmpty) {
      json['orderItemsId'] = orderItemsId;
    }
    return json;
  }

  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      provider: provider,
      status: status,
      amount: amount,
      paidAt: paidAt,
      orderId: orderId,
      orders: orders,
      subscriptionId: subscriptionId,
      subscription: subscription,
      userId: userId,
      shopId: shopId,
      orderItemsId: orderItemsId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory PaymentApiModel.fromEntity(PaymentEntity entity) {
    return PaymentApiModel(
      id: entity.id,
      provider: entity.provider,
      status: entity.status,
      amount: entity.amount,
      paidAt: entity.paidAt,
      orderId: entity.orderId,
      orders: entity.orders,
      subscriptionId: entity.subscriptionId,
      subscription: entity.subscription,
      userId: entity.userId,
      shopId: entity.shopId,
      orderItemsId: entity.orderItemsId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Get the full order object if it was populated from API
  Map<String, dynamic>? getPopulatedOrder() =>
      orderData is Map ? orderData : null;

  /// Get full populated order list if API returned a list
  List<Map<String, dynamic>>? getPopulatedOrders() {
    if (orderData is List) {
      return (orderData as List).whereType<Map<String, dynamic>>().toList();
    }
    if (orderData is Map<String, dynamic>) {
      return [orderData as Map<String, dynamic>];
    }
    return null;
  }

  /// Get the full user object if it was populated from API
  Map<String, dynamic>? getPopulatedUser() => userData is Map ? userData : null;

  /// Get the full subscription object if it was populated from API
  Map<String, dynamic>? getPopulatedSubscription() =>
      subscriptionData is Map ? subscriptionData : null;

  /// Get the full shop object if it was populated from API (includes address)
  Map<String, dynamic>? getPopulatedShop() => shopData is Map ? shopData : null;

  /// Get address from populated shop data
  Map<String, dynamic>? getPopulatedAddressFromShop() {
    final shopObj = getPopulatedShop();
    if (shopObj != null && shopObj['addressId'] is Map) {
      return shopObj['addressId'] as Map<String, dynamic>;
    }
    return null;
  }
}
