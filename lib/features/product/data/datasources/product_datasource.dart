import 'package:resub/features/product/data/models/product_model.dart';

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
