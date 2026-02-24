import 'dart:io';

import 'package:resub/features/shop/domain/entities/shop_entity.dart';

class ShopApiModel {
  final String? id;
  final String? name;
  final String? pickupInfo;
  final String? about;
  final bool? acceptsSubscription;
  final String? addressId;
  final String? shopBanner;
  final File? shopBannerFile;
  final String? userId;
  final String? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // Populated fields (for display only)
  final String? addressLabel;
  final String? addressLine1;
  final String? categoryName;

  ShopApiModel({
    this.id,
    this.name,
    this.pickupInfo,
    this.about,
    this.acceptsSubscription,
    this.addressId,
    this.shopBanner,
    this.shopBannerFile,
    this.userId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.addressLabel,
    this.addressLine1,
    this.categoryName,
  });

  factory ShopApiModel.fromJson(Map<String, dynamic> json) {
    final addressData = json['addressId'];
    final categoryData = json['categoryId'];

    return ShopApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      pickupInfo: json['pickup_info'] as String?,
      about: json['about'] as String?,
      acceptsSubscription: json['accepts_subscription'] as bool? ?? false,
      addressId: addressData is Map
          ? addressData['_id'] as String?
          : addressData as String?,
      shopBanner: json['shop_banner'] as String?,
      userId: json['userId'] as String?,
      categoryId: categoryData is Map
          ? categoryData['_id'] as String?
          : categoryData as String?,
      // Only parse necessary populated fields
      addressLabel: addressData is Map ? addressData['label'] as String? : null,
      addressLine1: addressData is Map ? addressData['line1'] as String? : null,
      categoryName: categoryData is Map
          ? categoryData['name'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (pickupInfo != null) json['pickup_info'] = pickupInfo;
    if (about != null) json['about'] = about;
    if (acceptsSubscription != null) {
      json['accepts_subscription'] = acceptsSubscription;
    }
    if (addressId != null) json['addressId'] = addressId;
    if (shopBanner != null) json['shop_banner'] = shopBanner;
    if (userId != null) json['userId'] = userId;
    if (categoryId != null) json['categoryId'] = categoryId;
    return json;
  }

  ShopEntity toEntity() {
    return ShopEntity(
      id: id,
      name: name,
      pickupInfo: pickupInfo,
      about: about,
      acceptsSubscription: acceptsSubscription,
      addressId: addressId,
      shopBanner: shopBanner,
      userId: userId,
      categoryId: categoryId,
      addressLabel: addressLabel,
      addressLine1: addressLine1,
      categoryName: categoryName,
    );
  }

  factory ShopApiModel.fromEntity(ShopEntity entity) {
    return ShopApiModel(
      id: entity.id,
      name: entity.name,
      pickupInfo: entity.pickupInfo,
      about: entity.about,
      acceptsSubscription: entity.acceptsSubscription,
      addressId: entity.addressId,
      shopBanner: entity.shopBanner,
      shopBannerFile: entity.shopBannerFile,
      userId: entity.userId,
      categoryId: entity.categoryId,
    );
  }

  static List<ShopEntity> toEntityList(List<ShopApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
