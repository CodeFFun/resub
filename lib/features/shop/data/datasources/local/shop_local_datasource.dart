import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/shop/data/datasources/shop_datasource.dart';
import 'package:resub/features/shop/data/models/shop_hive_model.dart';

final shopLocalDatasourceProvider = Provider<IShopLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ShopLocalDatasource(hiveService: hiveService);
});

class ShopLocalDatasource implements IShopLocalDatasource {
  final HiveService _hiveService;

  ShopLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<ShopHiveModel> createShop(ShopHiveModel shopModel) async {
    try {
      final shop = await _hiveService.createShop(shopModel);
      return Future.value(shop);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> deleteShop(String id) async {
    try {
      final result = await _hiveService.deleteShop(id);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> deleteAllShops() async {
    try {
      await _hiveService.deleteAllShops();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<ShopHiveModel>> getAllShops() async {
    try {
      final shops = _hiveService.getAllShops();
      return Future.value(shops);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<ShopHiveModel?> getShopById(String id) async {
    try {
      final shop = _hiveService.getShopById(id);
      return Future.value(shop);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<ShopHiveModel>> getShopsByCategoryId(String categoryId) async {
    try {
      final shops = _hiveService.getShopsByCategoryId(categoryId);
      return Future.value(shops);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<ShopHiveModel>> getShopsByUserId(String userId) async {
    try {
      final shops = _hiveService.getShopsByUserId(userId);
      return Future.value(shops);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> updateShop(String id, ShopHiveModel shopModel) async {
    try {
      final result = await _hiveService.updateShop(id, shopModel);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }
}
