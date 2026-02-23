import 'package:flutter/material.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';

class CategoryForm extends StatefulWidget {
  final CategoryEntity? initialCategory;
  final List<String> shops;
  final Function(CategoryEntity)? onSubmit;
  final String submitButtonLabel;
  final bool showBackButton;

  const CategoryForm({
    super.key,
    this.initialCategory,
    required this.shops,
    this.onSubmit,
    this.submitButtonLabel = 'Add Category',
    this.showBackButton = false,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late List<bool> _selectedShops;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialCategory?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialCategory?.description ?? '',
    );

    // Initialize selected shops
    _selectedShops = List<bool>.filled(widget.shops.length, false);
    if (widget.initialCategory != null) {
      for (int i = 0; i < widget.shops.length; i++) {
        if (widget.initialCategory!.shopIds.contains(i.toString())) {
          _selectedShops[i] = true;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Get selected shop ids
      List<String> selectedShopIds = [];
      for (int i = 0; i < _selectedShops.length; i++) {
        if (_selectedShops[i]) {
          selectedShopIds.add(i.toString());
        }
      }

      final category = CategoryEntity(
        id: widget.initialCategory?.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        shopIds: selectedShopIds,
      );
      widget.onSubmit?.call(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.showBackButton ? 'Update Category' : 'Add New Category',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Name
                MyInputFormField(
                  controller: _nameController,
                  labelText: 'Category Name',
                  icon: const Icon(Icons.category_outlined),
                ),
                const SizedBox(height: 15),

                // Description
                MyInputFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  icon: const Icon(Icons.description_outlined),
                ),
                const SizedBox(height: 25),

                // Shops Checkboxes
                Text(
                  'Select Shops',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(
                      widget.shops.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index < widget.shops.length - 1 ? 8 : 0,
                        ),
                        child: CheckboxListTile(
                          value: _selectedShops[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedShops[index] = value ?? false;
                            });
                          },
                          title: Text(
                            widget.shops[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    text: widget.submitButtonLabel,
                    onPressed: _handleSubmit,
                  ),
                ),
                if (widget.showBackButton) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF92400E)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xFF92400E),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
