import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';
import 'package:resub/features/shop/presentation/widgets/shop_list_card.dart';
import 'package:resub/features/shop/presentation/widgets/category_chip_filter.dart';

class ShopListScreen extends ConsumerStatefulWidget {
  final String? initialSelectedCategory;

  const ShopListScreen({super.key, this.initialSelectedCategory});

  @override
  ConsumerState<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends ConsumerState<ShopListScreen> {
  late List<ShopEntity> _shops = [];
  late List<CategoryEntity> _categories = [];
  late String _selectedCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedCategory = widget.initialSelectedCategory ?? 'All';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShopData();
    });
  }

  Future<void> _loadShopData() async {
    await ref.read(shopViewModelProvider.notifier).getAllShops();
    await ref.read(categoryViewModelProvider.notifier).getAllShopCategories();
  }

  List<ShopEntity> get _filteredShops {
    if (_selectedCategory == 'All') {
      return _shops;
    }
    return _shops
        .where((shop) => shop.categoryName == _selectedCategory)
        .toList();
  }

  void _openShopDetails(ShopEntity shop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shop details for ${shop.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    ref.listen<CategoryState>(categoryViewModelProvider, (previous, next) {
      if (next.status == CategoryStatus.loaded) {
        setState(() {
          _categories = next.categories ?? [];
        });
      }
    });
    ref.listen<ShopState>(shopViewModelProvider, (previous, next) {
      if (next.status == ShopStatus.loaded && next.shops != null) {
        setState(() {
          _shops = next.shops!;
        });
      }
    });
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'All Shops',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        ),
      ),
      body: Column(
        children: [
          // Category Horizontal Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CategoryChipFilter(
                  categoryName: 'All',
                  isSelected: _selectedCategory == 'All',
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 'All';
                    });
                  },
                ),
                ..._categories.map((category) {
                  final categoryName = category.name ?? 'Unknown';
                  return CategoryChipFilter(
                    categoryName: categoryName,
                    isSelected: _selectedCategory == categoryName,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = categoryName;
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          // Shops List
          Expanded(
            child: _filteredShops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 64,
                          color:
                              appColors?.mutedText ??
                              colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No shops yet',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                appColors?.secondaryText ??
                                colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for new shops',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                appColors?.mutedText ??
                                colorScheme.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredShops.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final shop = _filteredShops[index];
                      return ShopListCard(
                        shop: shop,
                        onTap: () => _openShopDetails(shop),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
