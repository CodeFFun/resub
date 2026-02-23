import 'package:flutter/material.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/presentation/widgets/product_form.dart';

class UpdateProductScreen extends StatelessWidget {
  final ProductEntity product;
  final Function(ProductEntity) onProductUpdated;
  final List<String> shops;
  final List<String> categories;

  const UpdateProductScreen({
    super.key,
    required this.product,
    required this.onProductUpdated,
    required this.shops,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ProductForm(
      initialProduct: product,
      shops: shops,
      categories: categories,
      submitButtonLabel: 'Update',
      showBackButton: true,
      onSubmit: onProductUpdated,
    );
  }
}
