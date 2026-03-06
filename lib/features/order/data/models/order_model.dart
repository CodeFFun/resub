import 'package:resub/features/order/data/models/order_item_model.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';

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

  ShopInfo toEntity() {
    return ShopInfo(id: id, name: name);
  }

  factory ShopInfoApiModel.fromEntity(ShopInfo entity) {
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
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    // Handle subscriptionId - could be String or Map
    String? subscriptionIdStr;
    if (json['subscriptionId'] != null) {
      if (json['subscriptionId'] is String) {
        subscriptionIdStr = json['subscriptionId'] as String;
      } else if (json['subscriptionId'] is Map<String, dynamic>) {
        subscriptionIdStr =
            (json['subscriptionId'] as Map<String, dynamic>)['_id'] as String?;
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

    return OrderApiModel(
      id: json['_id'] as String?,
      orderItemsId: json['orderItemsId'] != null
          ? (json['orderItemsId'] as List)
                .map(
                  (item) =>
                      OrderItemApiModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : null,
      shopId: shopIdModel,
      deliveryType: json['delivery_type'] as String?,
      scheduleFor: json['schedule_for'] != null
          ? DateTime.parse(json['schedule_for'] as String)
          : null,
      subscriptionId: subscriptionIdStr,
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

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderItemsId: orderItemsId?.map((item) => item.toEntity()).toList(),
      shopId: shopId?.toEntity(),
      deliveryType: deliveryType,
      scheduleFor: scheduleFor,
      subscriptionId: subscriptionId,
      userId: userId,
    );
  }

  factory OrderApiModel.fromEntity(OrderEntity entity) {
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
      userId: entity.userId,
    );
  }

  static List<OrderEntity> toEntityList(List<OrderApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
