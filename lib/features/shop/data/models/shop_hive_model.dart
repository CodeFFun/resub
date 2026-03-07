import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

part 'shop_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.shopsTypeId)
class ShopHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? pickupInfo;

  @HiveField(3)
  final String? about;

  @HiveField(4)
  final bool? acceptsSubscription;

  @HiveField(5)
  final String? addressId;

  @HiveField(6)
  final String? shopBanner;

  @HiveField(7)
  final String? userId;

  @HiveField(8)
  final String? categoryId;

  @HiveField(9)
  final String? addressLabel;

  @HiveField(10)
  final String? addressLine1;

  @HiveField(11)
  final String? categoryName;

  ShopHiveModel({
    this.id,
    this.name,
    this.pickupInfo,
    this.about,
    this.acceptsSubscription,
    this.addressId,
    this.shopBanner,
    this.userId,
    this.categoryId,
    this.addressLabel,
    this.addressLine1,
    this.categoryName,
  });

  // From entity
  factory ShopHiveModel.fromEntity(ShopEntity entity) {
    return ShopHiveModel(
      id: entity.id,
      name: entity.name,
      pickupInfo: entity.pickupInfo,
      about: entity.about,
      acceptsSubscription: entity.acceptsSubscription,
      addressId: entity.addressId,
      shopBanner: entity.shopBanner,
      userId: entity.userId,
      categoryId: entity.categoryId,
      addressLabel: entity.addressLabel,
      addressLine1: entity.addressLine1,
      categoryName: entity.categoryName,
    );
  }

  // To entity
  ShopEntity toEntity() {
    return ShopEntity(
      id: id,
      name: name,
      pickupInfo: pickupInfo,
      about: about,
      acceptsSubscription: acceptsSubscription,
      addressId: addressId,
      shopBanner: shopBanner,
      shopBannerFile: null, // File cannot be stored in Hive
      userId: userId,
      categoryId: categoryId,
      addressLabel: addressLabel,
      addressLine1: addressLine1,
      categoryName: categoryName,
    );
  }
}
