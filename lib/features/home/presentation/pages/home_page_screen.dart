import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/pages/customer/shop_list_screen.dart';
import 'package:resub/features/shop/presentation/pages/customer/shop_details_screen.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';
import '../widgets/category_card.dart';
import '../widgets/subscription_shop_card.dart';
import '../widgets/shop_card.dart';
import '../widgets/section_header.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  late List<CategoryEntity> _categories = [];
  late List<ShopEntity> _shops = [];

  final Map<String, String> _categoryIcons = {
    'Electronics & Technology': '💻',
    'Fashion&Apparel': '👕',
    'Fashion & Apparel': '👕',
    'Home&Living': '🏠',
    'Home & Living': '🏠',
    'Food & Beverages': '🍕',
    'Sport & Fitenss': '⚽',
    'Sport & Fitness': '⚽',
    'Beauty & Personal Care': '💄',
    'Books & Media': '📚',
    'Toys & Games': '🎮',
    'Automotive': '🚗',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    await ref.read(categoryViewModelProvider.notifier).getAllShopCategories();
    await ref.read(shopViewModelProvider.notifier).getAllShops();
  }

  String _getIconForCategory(String categoryName) {
    return _categoryIcons[categoryName] ?? '📦';
  }

  final List<Map<String, String>> categories = [
    {'name': 'Food', 'icon': '🍕'},
    {'name': 'Grocery', 'icon': '🛒'},
    {'name': 'Pharmacy', 'icon': '💊'},
    {'name': 'Parcel', 'icon': '📦'},
    {'name': 'Frozen Food', 'icon': '🥒'},
    {'name': 'Alcohol', 'icon': '🍺'},
  ];

  List<ShopEntity> get subscriptionShops {
    return _shops.where((shop) => shop.acceptsSubscription == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CategoryState>(categoryViewModelProvider, (previous, next) {
      if (next.status == CategoryStatus.loaded) {
        setState(() {
          _categories = next.categories ?? [];
        });
      }
    });
    ref.listen<ShopState>(shopViewModelProvider, (previous, next) {
      if (next.status == ShopStatus.loaded) {
        setState(() {
          _shops = next.shops ?? [];
        });
      }
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'What do you feel like today?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                            itemCount: _categories.isEmpty
                                ? categories.length
                                : _categories.length,
                            itemBuilder: (context, index) {
                              if (_categories.isEmpty) {
                                final category = categories[index];
                                return CategoryCard(
                                  name: category['name']!,
                                  icon: category['icon']!,
                                  onTap: () {
                                    AppRoutes.push(
                                      context,
                                      ShopListScreen(
                                        initialSelectedCategory:
                                            category['name']!,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                final category = _categories[index];
                                final categoryName = category.name ?? 'Unknown';
                                return CategoryCard(
                                  name: categoryName,
                                  icon: _getIconForCategory(categoryName),
                                  onTap: () {
                                    AppRoutes.push(
                                      context,
                                      ShopListScreen(
                                        initialSelectedCategory: categoryName,
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Hot & Exclusive Deals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Grab it before they are gone!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          subscriptionShops.isEmpty
                              ? Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No subscription shops available',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 200,
                                  child: PageView.builder(
                                    itemCount: subscriptionShops.length,
                                    itemBuilder: (context, index) {
                                      final shop = subscriptionShops[index];
                                      return SubscriptionShopCard(
                                        name: shop.name ?? 'Unknown',
                                        image: shop.shopBanner ?? '',
                                        shopId: shop.id,
                                        onTap: shop.id != null
                                            ? () {
                                                AppRoutes.push(
                                                  context,
                                                  ShopDetailsScreen(
                                                    shopId: shop.id,
                                                  ),
                                                );
                                              }
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(
                        title: 'All Shops',
                        subtitle: 'Browse all the shops',
                        onViewAll: () {
                          AppRoutes.push(
                            context,
                            ShopListScreen(initialSelectedCategory: 'All'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: _shops.length.clamp(0, 12),
                        itemBuilder: (context, index) {
                          final shop = _shops[index];
                          return ShopCard(
                            name: shop.name ?? 'Unknown',
                            category: shop.categoryName ?? 'Unknown',
                            image:
                                shop.shopBanner ??
                                'assets/images/default_shop.jpg',
                            shopId: shop.id,
                            onTap: shop.id != null
                                ? () {
                                    AppRoutes.push(
                                      context,
                                      ShopDetailsScreen(shopId: shop.id),
                                    );
                                  }
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
