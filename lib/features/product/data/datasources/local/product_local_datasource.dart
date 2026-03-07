import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/product/data/datasources/product_datasource.dart';
import 'package:resub/features/product/data/models/product_hive_model.dart';

final productLocalDatasourceProvider = Provider<IProductLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ProductLocalDatasource(hiveService: hiveService);
});

class ProductLocalDatasource implements IProductLocalDatasource {
  final HiveService _hiveService;

  ProductLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<ProductHiveModel> createProduct(ProductHiveModel productModel) async {
    try {
      final result = await _hiveService.createProduct(productModel);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try{
    final result = await _hiveService.deleteProduct(id);
    return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> deleteAllProducts() async {
    return await _hiveService.deleteAllProducts();
  }

  @override
  Future<List<ProductHiveModel>> getAllProducts() async {
    try{
      final result =  _hiveService.getAllProducts();
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<ProductHiveModel?> getProductById(String id) async {
    try{
      final result =  _hiveService.getProductById(id);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<ProductHiveModel>> getProductsByCategoryId(
    String categoryId,
  ) async {
    try{
      final result =  _hiveService.getProductsByCategoryId(categoryId);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<ProductHiveModel>> getProductsByShopId(String shopId) async {
    try{
      final result =  _hiveService.getProductsByShopId(shopId);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> updateProduct(String id, ProductHiveModel productModel) async {
    try{
      final result = await _hiveService.updateProduct(id, productModel);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }
}
