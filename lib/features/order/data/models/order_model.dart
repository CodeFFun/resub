import 'package:resub/features/order/data/models/order_item_model.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart'
    as order_entities;
import 'package:resub/features/subscription/data/models/subscription_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';

class ShopInfoApiModel {
  final String? id;
  final String? name;

  ShopInfoApiModel({this.id, this.name});

  factory ShopInfoApiModel.fromJson(Map<String, dynamic> json) {
    return ShopInfoApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (name != null) json['name'] = name;
    return json;
  }

  order_entities.ShopInfo toEntity() {
    return order_entities.ShopInfo(id: id, name: name);
  }

  factory ShopInfoApiModel.fromEntity(order_entities.ShopInfo entity) {
    return ShopInfoApiModel(id: entity.id, name: entity.name);
  }
}

class OrderApiModel {
  final String? id;
  final List<OrderItemApiModel>? orderItemsId;
  final ShopInfoApiModel? shopId;
  final String? deliveryType;
  final DateTime? scheduleFor;
  final String? subscriptionId;
  final SubscriptionEntity? subscription;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderApiModel({
    this.id,
    this.orderItemsId,
    this.shopId,
    this.deliveryType,
    this.scheduleFor,
    this.subscriptionId,
    this.subscription,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    // Handle subscriptionId - could be String or Map
    String? subscriptionIdStr;
    SubscriptionEntity? subscriptionEntity;
    if (json['subscriptionId'] != null) {
      try {
        if (json['subscriptionId'] is String) {
          subscriptionIdStr = json['subscriptionId'] as String;
        } else if (json['subscriptionId'] is Map<String, dynamic>) {
          final subMap = json['subscriptionId'] as Map<String, dynamic>;
          subscriptionIdStr = subMap['_id'] as String?;
          subscriptionEntity = SubscriptionApiModel.fromJson(subMap).toEntity();
        }
      } catch (e) {
        // Silently handle subscription parsing errors
      }
    }

    // Handle userId - could be String or Map
    String? userIdStr;
    if (json['userId'] != null) {
      if (json['userId'] is String) {
        userIdStr = json['userId'] as String;
      } else if (json['userId'] is Map<String, dynamic>) {
        userIdStr = (json['userId'] as Map<String, dynamic>)['_id'] as String?;
      }
    }

    // Handle shopId - could be String or Map
    ShopInfoApiModel? shopIdModel;
    if (json['shopId'] != null) {
      if (json['shopId'] is String) {
        shopIdModel = ShopInfoApiModel(id: json['shopId'] as String);
      } else if (json['shopId'] is Map<String, dynamic>) {
        shopIdModel = ShopInfoApiModel.fromJson(
          json['shopId'] as Map<String, dynamic>,
        );
      }
    }
    List<OrderItemApiModel>? orderItems;
    if (json['orderItemsId'] != null) {
      try {
        final itemsList = json['orderItemsId'] as List;
        orderItems = itemsList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return OrderItemApiModel.fromJson(item);
              } else if (item is String) {
                return OrderItemApiModel(id: item);
              }
              return null;
            })
            .whereType<OrderItemApiModel>()
            .toList();
      } catch (e) {
        // Silently handle orderItems parsing errors
      }
    }

    return OrderApiModel(
      id: json['_id'] as String?,
      orderItemsId: orderItems,
      shopId: shopIdModel,
      deliveryType: json['delivery_type'] as String?,
      scheduleFor: json['schedule_for'] != null
          ? DateTime.parse(json['schedule_for'] as String)
          : null,
      subscriptionId: subscriptionIdStr,
      subscription: subscriptionEntity,
      userId: userIdStr,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (orderItemsId != null) {
      json['orderItemsId'] = orderItemsId!
          .map((item) => item.id) // Send only the ID strings
          .toList();
    }
    if (shopId != null) json['shopId'] = shopId!.id; // Send only the ID string
    if (deliveryType != null) json['delivery_type'] = deliveryType;
    if (scheduleFor != null) {
      json['schedule_for'] = scheduleFor?.toIso8601String();
    }
    if (subscriptionId != null) json['subscriptionId'] = subscriptionId;
    if (userId != null) json['userId'] = userId;
    return json;
  }

  order_entities.OrderEntity toEntity() {
    return order_entities.OrderEntity(
      id: id,
      orderItemsId: orderItemsId?.map((item) => item.toEntity()).toList(),
      shopId: shopId?.toEntity(),
      deliveryType: deliveryType,
      scheduleFor: scheduleFor,
      subscriptionId: subscriptionId,
      subscription: subscription,
      userId: userId,
    );
  }

  factory OrderApiModel.fromEntity(order_entities.OrderEntity entity) {
    return OrderApiModel(
      id: entity.id,
      orderItemsId: entity.orderItemsId
          ?.map((item) => OrderItemApiModel.fromEntity(item))
          .toList(),
      shopId: entity.shopId != null
          ? ShopInfoApiModel.fromEntity(entity.shopId!)
          : null,
      deliveryType: entity.deliveryType,
      scheduleFor: entity.scheduleFor,
      subscriptionId: entity.subscriptionId,
      subscription: entity.subscription,
      userId: entity.userId,
    );
  }

  static List<order_entities.OrderEntity> toEntityList(
    List<OrderApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
