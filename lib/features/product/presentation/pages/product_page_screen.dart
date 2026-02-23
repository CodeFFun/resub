import 'package:flutter/material.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/presentation/pages/create_product_screen.dart';
import 'package:resub/features/product/presentation/pages/update_product_screen.dart';
import 'package:resub/features/product/presentation/widgets/product_card.dart';

class ProductPageScreen extends StatefulWidget {
  const ProductPageScreen({super.key});

  @override
  State<ProductPageScreen> createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreen> {
  late List<ProductEntity> _products;
  late List<String> _shops;
  late List<String> _categories;
  late String _selectedShopFilter;

  @override
  void initState() {
    super.initState();
    // Initialize with dummy shops and categories
    _shops = ['Fresh Bakery', 'Tech Store', 'Fashion Hub', 'Book World'];

    _categories = ['Food & Bakery', 'Electronics', 'Clothing', 'Books'];

    // Initialize with dummy products
    _products = [
      const ProductEntity(
        id: '1',
        name: 'Croissant',
        description: 'Fresh butter croissant',
        basePrice: 150,
        stockQuantity: 50,
        discount: 10,
        shopIds: ['0'], // Fresh Bakery
        categoryId: '0', // Food & Bakery
      ),
      const ProductEntity(
        id: '2',
        name: 'Bread Loaf',
        description: 'Whole wheat bread loaf',
        basePrice: 100,
        stockQuantity: 30,
        discount: 5,
        shopIds: ['0'], // Fresh Bakery
        categoryId: '0', // Food & Bakery
      ),
      const ProductEntity(
        id: '3',
        name: 'Laptop',
        description: 'High performance laptop',
        basePrice: 50000,
        stockQuantity: 5,
        discount: 15,
        shopIds: ['1'], // Tech Store
        categoryId: '1', // Electronics
      ),
    ];

    _selectedShopFilter = 'All Shops';
  }

  List<ProductEntity> _getFilteredProducts() {
    if (_selectedShopFilter == 'All Shops') {
      return _products;
    }
    final shopIndex = _shops.indexOf(_selectedShopFilter);
    return _products
        .where((product) => product.shopIds.contains(shopIndex.toString()))
        .toList();
  }

  String _getCategoryName(String categoryId) {
    int index = int.tryParse(categoryId) ?? 0;
    if (index >= 0 && index < _categories.length) {
      return _categories[index];
    }
    return 'Unknown';
  }

  void _handleAddProduct(ProductEntity product) {
    setState(() {
      _products.add(
        product.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
      );
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleUpdateProduct(ProductEntity product) {
    setState(() {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleDeleteProduct(String id) {
    setState(() {
      _products.removeWhere((product) => product.id == id);
    });
  }

  void _openCreateProductScreen() {
    AppRoutes.push(
      context,
      CreateProductScreen(
        onProductCreated: _handleAddProduct,
        shops: _shops,
        categories: _categories,
      ),
    );
  }

  void _openUpdateProductScreen(ProductEntity product) {
    AppRoutes.push(
      context,
      UpdateProductScreen(
        product: product,
        onProductUpdated: _handleUpdateProduct,
        shops: _shops,
        categories: _categories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Products',
          style: TextStyle(
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
      body: Column(
        children: [
          // Shop Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButton<String>(
                value: _selectedShopFilter,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down),
                items: [
                  const DropdownMenuItem<String>(
                    value: 'All Shops',
                    child: Text('All Shops'),
                  ),
                  ..._shops.map((String shop) {
                    return DropdownMenuItem<String>(
                      value: shop,
                      child: Text(shop),
                    );
                  }).toList(),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedShopFilter = newValue;
                    });
                  }
                },
              ),
            ),
          ),

          // Products List
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new product to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        categoryName: _getCategoryName(product.categoryId),
                        onEdit: () => _openUpdateProductScreen(product),
                        onDelete: () => _handleDeleteProduct(product.id ?? ''),
                      );
                    },
                  ),
          ),

          // Add Product Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openCreateProductScreen,
                icon: const Icon(Icons.add),
                label: const Text('Add New Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF92400E),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
