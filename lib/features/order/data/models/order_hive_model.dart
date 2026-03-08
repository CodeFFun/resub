import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/data/models/order_item_hive_model.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/subscription/data/models/subscription_hive_model.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.orderTypeId)
class OrderHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final List<String>? orderItemsIds;

  @HiveField(2)
  final String? shopId;

  @HiveField(3)
  final String? shopName;

  @HiveField(4)
  final String? deliveryType;

  @HiveField(5)
  final DateTime? scheduleFor;

  @HiveField(6)
  final String? subscriptionId;

  @HiveField(7)
  final String? userId;

  // Non-persisted fields for populated relationships
  List<OrderItemHiveModel>? _orderItems;
  SubscriptionHiveModel? _subscription;

  OrderHiveModel({
    this.id,
    this.orderItemsIds,
    this.shopId,
    this.shopName,
    this.deliveryType,
    this.scheduleFor,
    this.subscriptionId,
    this.userId,
    List<OrderItemHiveModel>? orderItems,
    SubscriptionHiveModel? subscription,
  }) : _orderItems = orderItems,
       _subscription = subscription;

  // Getters for populated relationships
  List<OrderItemHiveModel>? get orderItems => _orderItems;
  SubscriptionHiveModel? get subscription => _subscription;

  // Setters for populated relationships
  void setOrderItems(List<OrderItemHiveModel>? items) => _orderItems = items;
  void setSubscription(SubscriptionHiveModel? sub) => _subscription = sub;

  // From entity
  factory OrderHiveModel.fromEntity(OrderEntity entity) {
    // Convert OrderItemEntity objects to OrderItemHiveModel for population
    List<OrderItemHiveModel>? orderItems;
    if (entity.orderItemsId != null && entity.orderItemsId!.isNotEmpty) {
      orderItems = entity.orderItemsId!
          .map(
            (item) => OrderItemHiveModel(
              id: item.id,
              productId: item.productId?.id,
              productName: item.productId?.name,
              productBasePrice: item.productId?.basePrice,
              productDiscount: item.productId?.discount,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
            ),
          )
          .toList();
    }

    return OrderHiveModel(
      id: entity.id,
      orderItemsIds: entity.orderItemsId
          ?.map((item) => item.id ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
      shopId: entity.shopId?.id,
      shopName: entity.shopId?.name,
      deliveryType: entity.deliveryType,
      scheduleFor: entity.scheduleFor,
      subscriptionId: entity.subscriptionId,
      userId: entity.userId,
      orderItems: orderItems,
    );
  }

  // To entity
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderItemsId: _orderItems != null
          ? _orderItems!.map((item) => item.toEntity()).toList()
          : (orderItemsIds != null && orderItemsIds!.isNotEmpty)
          ? orderItemsIds!.map((id) => OrderItemEntity(id: id)).toList()
          : [],
      shopId: shopId != null ? ShopInfo(id: shopId, name: shopName) : null,
      deliveryType: deliveryType,
      scheduleFor: scheduleFor,
      subscriptionId: subscriptionId,
      subscription: _subscription?.toEntity(),
      userId: userId,
    );
  }
}
