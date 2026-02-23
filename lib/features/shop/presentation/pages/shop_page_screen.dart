import 'package:flutter/material.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/pages/create_shop_screen.dart';
import 'package:resub/features/shop/presentation/pages/update_shop_screen.dart';
import 'package:resub/features/shop/presentation/widgets/shop_card.dart';

class ShopPageScreen extends StatefulWidget {
  const ShopPageScreen({super.key});

  @override
  State<ShopPageScreen> createState() => _ShopPageScreenState();
}

class _ShopPageScreenState extends State<ShopPageScreen> {
  late List<ShopEntity> _shops;
  late List<String> _categories;
  late List<String> _addresses;

  @override
  void initState() {
    super.initState();
    // Initialize with dummy data
    _shops = [
      const ShopEntity(
        id: '1',
        name: 'Fresh Bakery',
        image: null,
        about: 'Fresh baked goods daily',
        acceptsSubscription: true,
        category: 'Bakery',
        address: '123 Main Street, San Francisco',
      ),
    ];

    // Dummy categories and addresses
    _categories = ['Bakery', 'Electronics', 'Clothing', 'Groceries', 'Books'];
    _addresses = [
      '123 Main Street, San Francisco',
      '456 Oak Avenue, Los Angeles',
      '789 Pine Road, New York',
    ];
  }

  void _handleAddShop(ShopEntity shop) {
    setState(() {
      _shops.add(
        shop.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
      );
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleUpdateShop(ShopEntity shop) {
    setState(() {
      final index = _shops.indexWhere((s) => s.id == shop.id);
      if (index != -1) {
        _shops[index] = shop;
      }
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleDeleteShop(String id) {
    setState(() {
      _shops.removeWhere((shop) => shop.id == id);
    });
  }

  void _openCreateShopScreen() {
    AppRoutes.push(
      context,
      CreateShopScreen(
        onShopCreated: _handleAddShop,
        categories: _categories,
        addresses: _addresses,
      ),
    );
  }

  void _openUpdateShopScreen(ShopEntity shop) {
    AppRoutes.push(
      context,
      UpdateShopScreen(
        shop: shop,
        onShopUpdated: _handleUpdateShop,
        categories: _categories,
        addresses: _addresses,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Shops',
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
          Expanded(
            child: _shops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No shops yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new shop to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _shops.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final shop = _shops[index];
                      return ShopCard(
                        shop: shop,
                        onEdit: () => _openUpdateShopScreen(shop),
                        onDelete: () => _handleDeleteShop(shop.id ?? ''),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openCreateShopScreen,
                icon: const Icon(Icons.add),
                label: const Text('Add New Shop'),
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
