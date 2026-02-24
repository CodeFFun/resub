import 'package:flutter/material.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/widgets/shop_form.dart';

class CreateShopScreen extends StatelessWidget {
  final Function(ShopEntity) onShopCreated;
  final List<CategoryEntity> categories;
  final List<AddressEntity> addresses;

  const CreateShopScreen({
    super.key,
    required this.onShopCreated,
    required this.categories,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return ShopForm(
      categories: categories,
      addresses: addresses,
      submitButtonLabel: 'Add Shop',
      showBackButton: false,
      onSubmit: onShopCreated,
    );
  }
}
