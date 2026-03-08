import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/product/data/models/product_hive_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/entities/product_info_entity.dart';

part 'subscription_plan_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.subscriptionPlansTypeId)
class SubscriptionPlanHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final List<String>? productIds;

  @HiveField(2)
  final List<String>? productNames;

  @HiveField(3)
  final List<int>? productQuantities;

  @HiveField(4)
  final List<num>? productBasePrices;

  @HiveField(5)
  final List<double>? productDiscounts;

  @HiveField(6)
  final num? pricePerCycle;

  @HiveField(7)
  final int? frequency;

  @HiveField(8)
  final int? quantity;

  @HiveField(9)
  final bool? active;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  // Non-persisted field for populated products
  List<ProductHiveModel>? _products;

  SubscriptionPlanHiveModel({
    this.id,
    this.productIds,
    this.productNames,
    this.productQuantities,
    this.productBasePrices,
    this.productDiscounts,
    this.pricePerCycle,
    this.frequency,
    this.quantity,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  // Setter for populated products
  void setProducts(List<ProductHiveModel>? products) {
    _products = products;
  }

  // From entity
  factory SubscriptionPlanHiveModel.fromEntity(SubscriptionPlanEntity entity) {
    return SubscriptionPlanHiveModel(
      id: entity.id,
      productIds: entity.productId
          ?.map((p) => p.id ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
      productNames: entity.productId
          ?.map((p) => p.name ?? '')
          .where((name) => name.isNotEmpty)
          .toList(),
      productQuantities: entity.productId?.map((p) => p.quantity ?? 0).toList(),
      productBasePrices: entity.productId
          ?.map((p) => p.basePrice ?? 0)
          .toList(),
      productDiscounts: entity.productId
          ?.map((p) => (p.discount ?? 0).toDouble())
          .toList(),
      pricePerCycle: entity.pricePerCycle,
      frequency: entity.frequency,
      quantity: entity.quantity,
      active: entity.active,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To entity - returns populated products if available
  SubscriptionPlanEntity toEntity() {
    List<SubscriptionProductInfo>? products;

    if (_products != null && _products!.isNotEmpty) {
      // Convert populated ProductHiveModel to SubscriptionProductInfo
      products = _products!
          .map(
            (product) => SubscriptionProductInfo(
              id: product.id,
              name: product.name,
              basePrice: product.basePrice,
              discount: product.discount,
            ),
          )
          .toList();
    } else if (productIds != null && productIds!.isNotEmpty) {
      // Fallback to constructing from stored fields
      products = <SubscriptionProductInfo>[];
      for (int i = 0; i < productIds!.length; i++) {
        products.add(
          SubscriptionProductInfo(
            id: productIds![i],
            name: (productNames != null && i < productNames!.length)
                ? productNames![i]
                : null,
            quantity:
                (productQuantities != null && i < productQuantities!.length)
                ? productQuantities![i]
                : null,
            basePrice:
                (productBasePrices != null && i < productBasePrices!.length)
                ? productBasePrices![i]
                : null,
            discount: (productDiscounts != null && i < productDiscounts!.length)
                ? productDiscounts![i]
                : null,
          ),
        );
      }
    }

    return SubscriptionPlanEntity(
      id: id,
      productId: products,
      pricePerCycle: pricePerCycle,
      frequency: frequency,
      quantity: quantity,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
