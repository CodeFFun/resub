import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/product/presentation/state/product_state.dart';
import 'package:resub/features/product/presentation/view_models/product_view_model.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';
import '../../widgets/shop_header_card.dart';
import '../../widgets/product_list_item.dart';
import '../../../domain/entities/shop_entity.dart';
import '../../../../product/domain/entities/product_entity.dart';

class ShopDetailsScreen extends ConsumerStatefulWidget {
  final String? shopId;
  const ShopDetailsScreen({super.key, this.shopId});

  @override
  ConsumerState<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends ConsumerState<ShopDetailsScreen> {
  ShopEntity? _shop;
  late List<ProductEntity> _products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShopData();
    });
  }

  Future<void> _loadShopData() async {
    if (widget.shopId != null) {
      await ref
          .read(shopViewModelProvider.notifier)
          .getShopById(shopId: widget.shopId!);
      await ref
          .read(productViewModelProvider.notifier)
          .getProductsByShopId(shopId: widget.shopId!);
    }
  }

  // // Dummy product data
  // List<ProductEntity> get dummyProducts => const [
  //   ProductEntity(
  //     id: '1',
  //     name: 'Lunch Combo',
  //     description:
  //         'Chicken katsu curry with rice, chicken and avocado sushi 4pcs, chicken karaage 4pcs, miso soup',
  //     basePrice: 699,
  //     stockQuantity: 10,
  //     discount: 0,
  //     shopIds: ['1'],
  //     categoryId: '1',
  //   ),
  //   ProductEntity(
  //     id: '2',
  //     name: 'Edamame',
  //     description: 'Steamed young soybeans lightly salted and served warm',
  //     basePrice: 225,
  //     stockQuantity: 20,
  //     discount: 0,
  //     shopIds: ['1'],
  //     categoryId: '1',
  //   ),
  //   ProductEntity(
  //     id: '3',
  //     name: 'Chicken Teriyaki',
  //     description: 'Grilled chicken with teriyaki sauce served with rice',
  //     basePrice: 450,
  //     stockQuantity: 15,
  //     discount: 0,
  //     shopIds: ['1'],
  //     categoryId: '1',
  //   ),
  //   ProductEntity(
  //     id: '4',
  //     name: 'Salmon Sushi',
  //     description: 'Fresh salmon sushi 8 pieces',
  //     basePrice: 850,
  //     stockQuantity: 8,
  //     discount: 0,
  //     shopIds: ['1'],
  //     categoryId: '1',
  //   ),
  //   ProductEntity(
  //     id: '5',
  //     name: 'Gyoza',
  //     description: 'Pan-fried dumplings filled with pork and vegetables',
  //     basePrice: 350,
  //     stockQuantity: 25,
  //     discount: 0,
  //     shopIds: ['1'],
  //     categoryId: '1',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    ref.listen<ShopState>(shopViewModelProvider, (previous, next) {
      if (next.status == ShopStatus.loaded && next.shop != null) {
        setState(() {
          _shop = next.shop;
        });
      }
    });
    ref.listen<ProductState>(productViewModelProvider, (previous, next) {
      if (next.status == ProductStatus.loaded && next.products != null) {
        setState(() {
          _products = next.products!;
        });
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ShopHeaderCard(shop: _shop!)),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                  top: 50,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = _products[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ProductListItem(
                        product: product,
                        onLovePressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} added to favorites',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onCartPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  }, childCount: _products.length),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
