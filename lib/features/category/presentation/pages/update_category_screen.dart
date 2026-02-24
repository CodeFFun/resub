import 'package:flutter/material.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/presentation/widgets/category_form.dart';

class UpdateCategoryScreen extends StatelessWidget {
  final CategoryEntity category;
  final Function(CategoryEntity) onCategoryUpdated;
  final List<String> shops;

  const UpdateCategoryScreen({
    super.key,
    required this.category,
    required this.onCategoryUpdated,
    required this.shops,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryForm(
      initialCategory: category,
      shops: shops,
      submitButtonLabel: 'Update',
      showBackButton: true,
      onSubmit: onCategoryUpdated,
    );
  }
}
