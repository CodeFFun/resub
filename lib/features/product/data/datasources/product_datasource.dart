import 'package:resub/features/product/data/models/product_model.dart';
import 'package:resub/features/product/data/models/product_hive_model.dart';

// Remote Datasource Interface
abstract interface class IProductRemoteDatasource {
  Future<ProductApiModel> createProduct(
    String shopId,
    ProductApiModel productModel,
  );
  Future<ProductApiModel?> getProductById(String id);
  Future<List<ProductApiModel>> getProductsByShopId(String shopId);
  Future<ProductApiModel?> updateProduct(
    String id,
    ProductApiModel productModel,
  );
  Future<bool> deleteProduct(String id);
}

// Local Datasource Interface
abstract interface class IProductLocalDatasource {
  Future<ProductHiveModel> createProduct(ProductHiveModel productModel);
  Future<ProductHiveModel?> getProductById(String id);
  Future<List<ProductHiveModel>> getAllProducts();
  Future<List<ProductHiveModel>> getProductsByShopId(String shopId);
  Future<List<ProductHiveModel>> getProductsByCategoryId(String categoryId);
  Future<bool> updateProduct(String id, ProductHiveModel productModel);
  Future<bool> deleteProduct(String id);
  Future<void> deleteAllProducts();
}
