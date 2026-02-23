import 'package:flutter/material.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/presentation/widgets/product_form.dart';

class CreateProductScreen extends StatelessWidget {
  final Function(ProductEntity) onProductCreated;
  final List<String> shops;
  final List<String> categories;

  const CreateProductScreen({
    super.key,
    required this.onProductCreated,
    required this.shops,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ProductForm(
      shops: shops,
      categories: categories,
      submitButtonLabel: 'Add Product',
      showBackButton: false,
      onSubmit: onProductCreated,
    );
  }
}
