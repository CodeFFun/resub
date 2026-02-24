import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/presentation/state/address_state.dart';
import 'package:resub/features/address/presentation/view_models/address_view_model.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/pages/create_shop_screen.dart';
import 'package:resub/features/shop/presentation/pages/update_shop_screen.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';
import 'package:resub/features/shop/presentation/widgets/shop_card.dart';

class ShopPageScreen extends ConsumerStatefulWidget {
  const ShopPageScreen({super.key});

  @override
  ConsumerState<ShopPageScreen> createState() => _ShopPageScreenState();
}

class _ShopPageScreenState extends ConsumerState<ShopPageScreen> {
  late List<ShopEntity> _shops = [];
  late List<CategoryEntity> _categories = [];
  late List<AddressEntity> _addresses = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShopData();
    });
  }

  Future<void> _loadShopData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();
    if (userId != null) {
      await ref.read(shopViewModelProvider.notifier).getAllShopsOfUser();
      await ref.read(addressViewModelProvider.notifier).getAddressesOfUser();
      await ref.read(categoryViewModelProvider.notifier).getAllShopCategories();
    }
  }

  void _handleAddShop(ShopEntity shop) async {
    await ref.read(shopViewModelProvider.notifier).createShop(shopEntity: shop);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleUpdateShop(ShopEntity shop) async {
    await ref
        .read(shopViewModelProvider.notifier)
        .updateShop(shopId: shop.id ?? '', shopEntity: shop);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleDeleteShop(String id) async {
    await ref.read(shopViewModelProvider.notifier).deleteShop(shopId: id);
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
    ref.listen<ShopState>(shopViewModelProvider, (previous, next) {
      if (next.status == ShopStatus.loaded && next.shops != null) {
        setState(() {
          _shops = next.shops!;
        });
      }
      if (next.status == ShopStatus.deleted) {
        ref.read(shopViewModelProvider.notifier).getAllShopsOfUser();
      }
      if (next.status == ShopStatus.created) {
        ref.read(shopViewModelProvider.notifier).getAllShopsOfUser();
      }
      if (next.status == ShopStatus.updated) {
        ref.read(shopViewModelProvider.notifier).getAllShopsOfUser();
      }
    });
    ref.listen<AddressState>(addressViewModelProvider, (previous, next) {
      if (next.status == AddressStatus.loaded && next.addresses != null) {
        setState(() {
          _addresses = next.addresses!;
        });
      }
    });
    ref.listen<CategoryState>(categoryViewModelProvider, (previous, next) {
      if (next.status == CategoryStatus.loaded && next.categories != null) {
        setState(() {
          _categories = next.categories!;
        });
      }
    });
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
