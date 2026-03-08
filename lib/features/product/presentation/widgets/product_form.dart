import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/core/utils/responsive_utils.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

class ProductForm extends StatefulWidget {
  final ProductEntity? initialProduct;
  final List<ShopEntity> shops;
  final List<CategoryEntity> categories;
  final Function(ProductEntity)? onSubmit;
  final String submitButtonLabel;
  final bool showBackButton;

  const ProductForm({
    super.key,
    this.initialProduct,
    required this.shops,
    required this.categories,
    this.onSubmit,
    this.submitButtonLabel = 'Add Product',
    this.showBackButton = false,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _basePriceController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _discountController;
  late String _selectedShopId;
  late String _selectedCategoryId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialProduct?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialProduct?.description ?? '',
    );
    _basePriceController = TextEditingController(
      text: widget.initialProduct?.basePrice.toString() ?? '',
    );
    _stockQuantityController = TextEditingController(
      text: widget.initialProduct?.stockQuantity.toString() ?? '',
    );
    _discountController = TextEditingController(
      text: widget.initialProduct?.discount.toString() ?? '0',
    );

    // Initialize selected shop
    _selectedShopId = '';
    if (widget.initialProduct != null) {
      if (widget.initialProduct!.shopId != null) {
        _selectedShopId = widget.initialProduct!.shopId!;
      } else if (widget.initialProduct!.shopIds.isNotEmpty) {
        _selectedShopId = widget.initialProduct!.shopIds.first;
      }
    }
    if (_selectedShopId.isEmpty && widget.shops.isNotEmpty) {
      _selectedShopId = widget.shops.first.id ?? '';
    }

    // Initialize selected category
    _selectedCategoryId =
        widget.initialProduct?.categoryId ??
        (widget.categories.isNotEmpty ? widget.categories.first.id ?? '' : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _basePriceController.dispose();
    _stockQuantityController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedShopId.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a shop')));
        return;
      }

      if (_selectedCategoryId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final resolvedCategoryIds = <String>[_selectedCategoryId];

      final product = ProductEntity(
        id: widget.initialProduct?.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        basePrice: double.parse(_basePriceController.text.trim()),
        stockQuantity: int.parse(_stockQuantityController.text.trim()),
        discount: double.parse(_discountController.text.trim()),
        shopIds: [_selectedShopId],
        categoryId: _selectedCategoryId,
        shopId: _selectedShopId,
        categoryIds: resolvedCategoryIds,
      );
      widget.onSubmit?.call(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          widget.showBackButton ? 'Update Product' : 'Add New Product',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: context.rFont(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.rSpacing(20)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                MyInputFormField(
                  controller: _nameController,
                  labelText: 'Product Name',
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
                SizedBox(height: context.rHeight(15)),

                // Description
                MyInputFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  icon: const Icon(Icons.description_outlined),
                ),
                SizedBox(height: context.rHeight(15)),

                // Base Price
                MyInputFormField(
                  controller: _basePriceController,
                  labelText: 'Base Price',
                  icon: const Icon(Icons.currency_rupee),
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                SizedBox(height: context.rHeight(15)),

                // Stock Quantity
                MyInputFormField(
                  controller: _stockQuantityController,
                  labelText: 'Stock Quantity',
                  icon: const Icon(Icons.inventory_2_outlined),
                  inputType: TextInputType.number,
                ),
                SizedBox(height: context.rHeight(15)),

                // Discount
                MyInputFormField(
                  controller: _discountController,
                  labelText: 'Discount (%)',
                  icon: const Icon(Icons.percent),
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                SizedBox(height: context.rHeight(25)),

                // Category (Radio buttons - single select)
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: context.rFont(16),
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: context.rHeight(12)),
                Container(
                  padding: EdgeInsets.all(context.rSpacing(16)),
                  decoration: BoxDecoration(
                    color: appColors?.cardBackground ?? theme.cardColor,
                    borderRadius: BorderRadius.circular(context.rRadius(12)),
                    border: Border.all(
                      color: appColors?.border ?? theme.dividerColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(
                      widget.categories.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index < widget.categories.length - 1
                              ? context.rHeight(8)
                              : 0,
                        ),
                        child: RadioListTile<String>(
                          value: widget.categories[index].id ?? '',
                          groupValue: _selectedCategoryId,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCategoryId = value ?? '';
                            });
                          },
                          title: Text(
                            widget.categories[index].name ?? 'Unnamed category',
                            style: TextStyle(
                              fontSize: context.rFont(14),
                              color: colorScheme.onSurface,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          activeColor: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.rHeight(25)),

                Text(
                  'Select Shop',
                  style: TextStyle(
                    fontSize: context.rFont(16),
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: context.rHeight(12)),
                Container(
                  padding: EdgeInsets.all(context.rSpacing(16)),
                  decoration: BoxDecoration(
                    color: appColors?.cardBackground ?? theme.cardColor,
                    borderRadius: BorderRadius.circular(context.rRadius(12)),
                    border: Border.all(
                      color: appColors?.border ?? theme.dividerColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
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
                          bottom: index < widget.shops.length - 1
                              ? context.rHeight(8)
                              : 0,
                        ),
                        child: RadioListTile<String>(
                          value: widget.shops[index].id ?? '',
                          groupValue: _selectedShopId,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedShopId = value ?? '';
                            });
                          },
                          title: Text(
                            widget.shops[index].name ?? 'Unnamed shop',
                            style: TextStyle(
                              fontSize: context.rFont(14),
                              color: colorScheme.onSurface,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          activeColor: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.rHeight(30)),
                // Buttons
                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    text: widget.submitButtonLabel,
                    onPressed: _handleSubmit,
                  ),
                ),
                if (widget.showBackButton) ...[
                  SizedBox(height: context.rHeight(12)),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.primary),
                        padding: EdgeInsets.symmetric(
                          vertical: context.rHeight(12),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: context.rFont(16),
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
