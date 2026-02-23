import 'package:flutter/material.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';

class ProductForm extends StatefulWidget {
  final ProductEntity? initialProduct;
  final List<String> shops;
  final List<String> categories;
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
  late List<bool> _selectedShops;
  late String _selectedCategory;
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

    // Initialize selected shops
    _selectedShops = List<bool>.filled(widget.shops.length, false);
    if (widget.initialProduct != null) {
      for (int i = 0; i < widget.shops.length; i++) {
        if (widget.initialProduct!.shopIds.contains(i.toString())) {
          _selectedShops[i] = true;
        }
      }
    }

    // Initialize selected category
    _selectedCategory =
        widget.initialProduct?.categoryId ??
        (widget.categories.isNotEmpty ? '0' : '');
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
      // Get selected shop ids
      List<String> selectedShopIds = [];
      for (int i = 0; i < _selectedShops.length; i++) {
        if (_selectedShops[i]) {
          selectedShopIds.add(i.toString());
        }
      }

      if (selectedShopIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one shop')),
        );
        return;
      }

      final product = ProductEntity(
        id: widget.initialProduct?.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        basePrice: double.parse(_basePriceController.text.trim()),
        stockQuantity: int.parse(_stockQuantityController.text.trim()),
        discount: double.parse(_discountController.text.trim()),
        shopIds: selectedShopIds,
        categoryId: _selectedCategory,
      );
      widget.onSubmit?.call(product);
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
          widget.showBackButton ? 'Update Product' : 'Add New Product',
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
                // Product Name
                MyInputFormField(
                  controller: _nameController,
                  labelText: 'Product Name',
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
                const SizedBox(height: 15),

                // Description
                MyInputFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  icon: const Icon(Icons.description_outlined),
                ),
                const SizedBox(height: 15),

                // Base Price
                MyInputFormField(
                  controller: _basePriceController,
                  labelText: 'Base Price',
                  icon: const Icon(Icons.currency_rupee),
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 15),

                // Stock Quantity
                MyInputFormField(
                  controller: _stockQuantityController,
                  labelText: 'Stock Quantity',
                  icon: const Icon(Icons.inventory_2_outlined),
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 15),

                // Discount
                MyInputFormField(
                  controller: _discountController,
                  labelText: 'Discount (%)',
                  icon: const Icon(Icons.percent),
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 25),

                // Category (Radio buttons - single select)
                Text(
                  'Select Category',
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
                      widget.categories.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index < widget.categories.length - 1 ? 8 : 0,
                        ),
                        child: RadioListTile<String>(
                          value: index.toString(),
                          groupValue: _selectedCategory,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCategory = value ?? '';
                            });
                          },
                          title: Text(
                            widget.categories[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Shops (Checkboxes - multiple select)
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
