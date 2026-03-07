import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';

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

  OrderHiveModel({
    this.id,
    this.orderItemsIds,
    this.shopId,
    this.shopName,
    this.deliveryType,
    this.scheduleFor,
    this.subscriptionId,
    this.userId,
  });

  // From entity
  factory OrderHiveModel.fromEntity(OrderEntity entity) {
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
    );
  }

  // To entity
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderItemsId: [], // Order items should be fetched separately
      shopId: shopId != null ? ShopInfo(id: shopId, name: shopName) : null,
      deliveryType: deliveryType,
      scheduleFor: scheduleFor,
      subscriptionId: subscriptionId,
      subscription: null, // Subscription should be fetched separately
      userId: userId,
    );
  }
}
