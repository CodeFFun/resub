import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/category/data/datasources/category_datasource.dart';
import 'package:resub/features/category/data/models/shop_category_hive_model.dart';

final shopCategoryLocalDatasourceProvider =
    Provider<IShopCategoryLocalDatasource>((ref) {
      final hiveService = ref.watch(hiveServiceProvider);
      return ShopCategoryLocalDatasource(hiveService: hiveService);
    });

class ShopCategoryLocalDatasource implements IShopCategoryLocalDatasource {
  final HiveService _hiveService;

  ShopCategoryLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<ShopCategoryHiveModel> createShopCategory(
    ShopCategoryHiveModel categoryModel,
  ) async {
    return await _hiveService.createShopCategory(categoryModel);
  }

  @override
  Future<bool> deleteShopCategory(String id) async {
    return await _hiveService.deleteShopCategory(id);
  }

  @override
  Future<void> deleteAllShopCategories() async {
    return await _hiveService.deleteAllShopCategories();
  }

  @override
  Future<List<ShopCategoryHiveModel>> getAllShopCategories() async {
    return _hiveService.getAllShopCategories();
  }

  @override
  Future<ShopCategoryHiveModel?> getShopCategoryById(String id) async {
    return _hiveService.getShopCategoryById(id);
  }

  @override
  Future<bool> updateShopCategory(
    String id,
    ShopCategoryHiveModel categoryModel,
  ) async {
    return await _hiveService.updateShopCategory(id, categoryModel);
  }
}
