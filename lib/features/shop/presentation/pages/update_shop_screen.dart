import 'package:flutter/material.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/widgets/shop_form.dart';

class UpdateShopScreen extends StatelessWidget {
  final ShopEntity shop;
  final Function(ShopEntity) onShopUpdated;
  final List<CategoryEntity> categories;
  final List<AddressEntity> addresses;

  const UpdateShopScreen({
    super.key,
    required this.shop,
    required this.onShopUpdated,
    required this.categories,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return ShopForm(
      initialShop: shop,
      categories: categories,
      addresses: addresses,
      submitButtonLabel: 'Update',
      showBackButton: true,
      onSubmit: onShopUpdated,
    );
  }
}
