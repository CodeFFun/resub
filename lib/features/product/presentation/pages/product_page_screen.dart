import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/presentation/pages/create_product_screen.dart';
import 'package:resub/features/product/presentation/pages/update_product_screen.dart';
import 'package:resub/features/product/presentation/state/product_state.dart';
import 'package:resub/features/product/presentation/view_models/product_view_model.dart';
import 'package:resub/features/product/presentation/widgets/product_card.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';

class ProductPageScreen extends ConsumerStatefulWidget {
  const ProductPageScreen({super.key});

  @override
  ConsumerState<ProductPageScreen> createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends ConsumerState<ProductPageScreen> {
  late List<ProductEntity> _products = [];
  late List<ShopEntity> _shops = [];
  late List<CategoryEntity> _categories = [];
  late String _selectedShopFilter = 'All Shops';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShopData();
      _loadProductData();
      _loadCategoryData();
    });
  }

  Future<void> _loadShopData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();
    if (userId != null) {
      await ref.read(shopViewModelProvider.notifier).getAllShopsOfUser();
    }
  }

  Future<void> _loadProductData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();
    if (userId != null) {
      if (_selectedShopFilter != 'All Shops') {
        await ref
            .read(productViewModelProvider.notifier)
            .getProductsByShopId(shopId: _selectedShopFilter);
      }
    }
  }

  Future<void> _loadCategoryData({String? shopId}) async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();
    if (userId != null) {
      final resolvedShopId =
          shopId ??
          (_selectedShopFilter != 'All Shops'
              ? _selectedShopFilter
              : (_shops.isNotEmpty ? _shops.first.id : null));
      if (resolvedShopId == null || resolvedShopId.isEmpty) {
        return;
      }
      await ref
          .read(categoryViewModelProvider.notifier)
          .getCategoriesByShopId(shopId: resolvedShopId);
    }
  }

  List<ProductEntity> _getFilteredProducts() {
    if (_selectedShopFilter == 'All Shops') {
      return _products;
    }
    return _products.where((product) {
      if (product.shopId != null) {
        return product.shopId == _selectedShopFilter;
      }
      return product.shopIds.contains(_selectedShopFilter);
    }).toList();
  }

  String _getCategoryName(String categoryId) {
    final match = _categories.where((category) => category.id == categoryId);
    if (match.isNotEmpty) {
      return match.first.name ?? 'Unknown';
    }
    return 'Unknown';
  }

  void _handleAddProduct(ProductEntity product) async {
    await ref
        .read(productViewModelProvider.notifier)
        .createProduct(shopId: product.shopId ?? '', productEntity: product);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleUpdateProduct(ProductEntity product) async {
    await ref
        .read(productViewModelProvider.notifier)
        .updateProduct(productId: product.id ?? '', productEntity: product);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleDeleteProduct(String id) async {
    await ref
        .read(productViewModelProvider.notifier)
        .deleteProduct(productId: id);
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
    ref.listen<ProductState>(productViewModelProvider, (previous, next) {
      if (next.status == ProductStatus.loaded && next.products != null) {
        setState(() {
          _products = next.products!;
        });
      }
      if (next.status == ProductStatus.created) {
        ref
            .read(productViewModelProvider.notifier)
            .getProductsByShopId(shopId: _selectedShopFilter);
      }
      if (next.status == ProductStatus.deleted) {
        ref
            .read(productViewModelProvider.notifier)
            .getProductsByShopId(shopId: _selectedShopFilter);
      }
      if (next.status == ProductStatus.updated) {
        ref
            .read(productViewModelProvider.notifier)
            .getProductsByShopId(shopId: _selectedShopFilter);
      }
    });
    ref.listen<ShopState>(shopViewModelProvider, (previous, next) {
      if (next.status == ShopStatus.loaded && next.shops != null) {
        setState(() {
          _shops = next.shops!;
        });
        _loadCategoryData();
      }
    });
    ref.listen<CategoryState>(categoryViewModelProvider, (previous, next) {
      if (next.status == CategoryStatus.loaded && next.categories != null) {
        setState(() {
          _categories = next.categories!;
        });
      }
    });

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
                  ..._shops.map((shop) {
                    return DropdownMenuItem<String>(
                      value: shop.id,
                      child: Text(shop.name ?? 'Unnamed shop'),
                    );
                  }),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedShopFilter = newValue;
                    });
                    if (newValue != 'All Shops') {
                      ref
                          .read(productViewModelProvider.notifier)
                          .getProductsByShopId(shopId: newValue);
                    }
                    _loadCategoryData(shopId: newValue);
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
