import 'package:flutter/material.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/presentation/widgets/category_form.dart';

class CreateCategoryScreen extends StatelessWidget {
  final Function(CategoryEntity) onCategoryCreated;
  final List<String> shops;

  const CreateCategoryScreen({
    super.key,
    required this.onCategoryCreated,
    required this.shops,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryForm(
      shops: shops,
      submitButtonLabel: 'Add Category',
      showBackButton: false,
      onSubmit: onCategoryCreated,
    );
  }
}
