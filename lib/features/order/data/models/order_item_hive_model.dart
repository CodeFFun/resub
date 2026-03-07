import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';

part 'order_item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.orderItemsTypeId)
class OrderItemHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? productId;

  @HiveField(2)
  final String? productName;

  @HiveField(3)
  final double? productBasePrice;

  @HiveField(4)
  final int? productDiscount;

  @HiveField(5)
  final int? quantity;

  @HiveField(6)
  final double? unitPrice;

  OrderItemHiveModel({
    this.id,
    this.productId,
    this.productName,
    this.productBasePrice,
    this.productDiscount,
    this.quantity,
    this.unitPrice,
  });

  // From entity
  factory OrderItemHiveModel.fromEntity(OrderItemEntity entity) {
    return OrderItemHiveModel(
      id: entity.id,
      productId: entity.productId?.id,
      productName: entity.productId?.name,
      productBasePrice: entity.productId?.basePrice,
      productDiscount: entity.productId?.discount,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
    );
  }

  // To entity
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      productId: productId != null
          ? ProductInfo(
              id: productId,
              name: productName,
              basePrice: productBasePrice,
              discount: productDiscount,
            )
          : null,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }
}
