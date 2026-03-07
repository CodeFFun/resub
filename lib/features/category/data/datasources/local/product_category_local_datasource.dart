import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/category/data/datasources/category_datasource.dart';
import 'package:resub/features/category/data/models/product_category_hive_model.dart';

final productCategoryLocalDatasourceProvider =
    Provider<IProductCategoryLocalDatasource>((ref) {
      final hiveService = ref.watch(hiveServiceProvider);
      return ProductCategoryLocalDatasource(hiveService: hiveService);
    });

class ProductCategoryLocalDatasource
    implements IProductCategoryLocalDatasource {
  final HiveService _hiveService;

  ProductCategoryLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<ProductCategoryHiveModel> createProductCategory(
    ProductCategoryHiveModel categoryModel,
  ) async {
    try {
      final result = await _hiveService.createProductCategory(categoryModel);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> deleteProductCategory(String id) async {
    try {
      final result = await _hiveService.deleteProductCategory(id);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> deleteAllProductCategories() async {
    return await _hiveService.deleteAllProductCategories();
  }

  @override
  Future<List<ProductCategoryHiveModel>> getAllProductCategories() async {
    try {
      final result = _hiveService.getAllProductCategories();
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<ProductCategoryHiveModel>> getProductCategoriesByShopId(
    String shopId,
  ) async {
    try {
      final result = _hiveService.getProductCategoriesByShopId(shopId);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<ProductCategoryHiveModel?> getProductCategoryById(String id) async {
    try {
      final result = _hiveService.getProductCategoryById(id);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> updateProductCategory(
    String id,
    ProductCategoryHiveModel categoryModel,
  ) async {
    try {
      final result = await _hiveService.updateProductCategory(
        id,
        categoryModel,
      );
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }
}
