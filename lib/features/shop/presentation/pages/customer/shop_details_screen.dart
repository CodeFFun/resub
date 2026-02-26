import 'package:flutter/material.dart';
import '../../widgets/shop_header_card.dart';
import '../../widgets/product_list_item.dart';
import '../../../domain/entities/shop_entity.dart';
import '../../../../product/domain/entities/product_entity.dart';

class ShopDetailsScreen extends StatelessWidget {
  final String? shopId;

  const ShopDetailsScreen({super.key, this.shopId});

  // Dummy shop data
  ShopEntity get dummyShop => const ShopEntity(
    id: '1',
    name: 'Hiyori Japanese Restaurant',
    addressLabel: 'Thamel, Kathmandu',
    addressLine1: 'Thamel, Kathmandu',
    shopBanner: 'https://example.com/ramen.jpg',
  );

  // Dummy product data
  List<ProductEntity> get dummyProducts => const [
    ProductEntity(
      id: '1',
      name: 'Lunch Combo',
      description:
          'Chicken katsu curry with rice, chicken and avocado sushi 4pcs, chicken karaage 4pcs, miso soup',
      basePrice: 699,
      stockQuantity: 10,
      discount: 0,
      shopIds: ['1'],
      categoryId: '1',
    ),
    ProductEntity(
      id: '2',
      name: 'Edamame',
      description: 'Steamed young soybeans lightly salted and served warm',
      basePrice: 225,
      stockQuantity: 20,
      discount: 0,
      shopIds: ['1'],
      categoryId: '1',
    ),
    ProductEntity(
      id: '3',
      name: 'Chicken Teriyaki',
      description: 'Grilled chicken with teriyaki sauce served with rice',
      basePrice: 450,
      stockQuantity: 15,
      discount: 0,
      shopIds: ['1'],
      categoryId: '1',
    ),
    ProductEntity(
      id: '4',
      name: 'Salmon Sushi',
      description: 'Fresh salmon sushi 8 pieces',
      basePrice: 850,
      stockQuantity: 8,
      discount: 0,
      shopIds: ['1'],
      categoryId: '1',
    ),
    ProductEntity(
      id: '5',
      name: 'Gyoza',
      description: 'Pan-fried dumplings filled with pork and vegetables',
      basePrice: 350,
      stockQuantity: 25,
      discount: 0,
      shopIds: ['1'],
      categoryId: '1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ShopHeaderCard(shop: dummyShop)),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = dummyProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ProductListItem(
                        product: product,
                        onLovePressed: () {
                          // Handle love button press
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
                          // Handle cart button press
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  }, childCount: dummyProducts.length),
                ),
              ),
            ],
          ),
          // Floating back button
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
                      color: Colors.black.withOpacity(0.1),
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
