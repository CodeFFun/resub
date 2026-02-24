import 'dart:io';

import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
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
  // Populated fields (for display only)
  final String? addressLabel;
  final String? addressLine1;
  final String? categoryName;

  const ShopEntity({
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
    this.addressLabel,
    this.addressLine1,
    this.categoryName,
  });

  ShopEntity copyWith({
    String? id,
    String? name,
    String? pickupInfo,
    String? about,
    bool? acceptsSubscription,
    String? addressId,
    String? shopBanner,
    File? shopBannerFile,
    String? userId,
    String? categoryId,
    String? addressLabel,
    String? addressLine1,
    String? categoryName,
  }) {
    return ShopEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      pickupInfo: pickupInfo ?? this.pickupInfo,
      about: about ?? this.about,
      acceptsSubscription: acceptsSubscription ?? this.acceptsSubscription,
      addressId: addressId ?? this.addressId,
      shopBanner: shopBanner ?? this.shopBanner,
      shopBannerFile: shopBannerFile ?? this.shopBannerFile,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      addressLabel: addressLabel ?? this.addressLabel,
      addressLine1: addressLine1 ?? this.addressLine1,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    pickupInfo,
    about,
    acceptsSubscription,
    addressId,
    shopBanner,
    shopBannerFile,
    userId,
    categoryId,
    addressLabel,
    addressLine1,
    categoryName,
  ];
}
