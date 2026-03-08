import 'package:resub/features/category/data/models/category_model.dart';
import 'package:resub/features/category/data/models/shop_category_hive_model.dart';
import 'package:resub/features/category/data/models/product_category_hive_model.dart';

// Remote Datasource Interface
abstract interface class ICategoryRemoteDatasource {
  Future<CategoryApiModel> createProductCategory(
    CategoryApiModel categoryModel,
  );
  Future<CategoryApiModel?> getProductCategoryById(String id);
  Future<List<CategoryApiModel>> getAllProductCategories();
  Future<List<CategoryApiModel>> getAllShopCategories();
  Future<List<CategoryApiModel>> getAllProductCategoriesByShopId(String shopId);
  Future<CategoryApiModel?> updateProductCategory(
    String id,
    CategoryApiModel categoryModel,
  );
  Future<bool> deleteProductCategory(String id);
}

// Local Datasource Interfaces
abstract interface class IShopCategoryLocalDatasource {
  Future<ShopCategoryHiveModel> createShopCategory(
    ShopCategoryHiveModel categoryModel,
  );
  Future<ShopCategoryHiveModel?> getShopCategoryById(String id);
  Future<List<ShopCategoryHiveModel>> getAllShopCategories();
  Future<bool> updateShopCategory(
    String id,
    ShopCategoryHiveModel categoryModel,
  );
  Future<bool> deleteShopCategory(String id);
  Future<void> deleteAllShopCategories();
}

abstract interface class IProductCategoryLocalDatasource {
  Future<ProductCategoryHiveModel> createProductCategory(
    ProductCategoryHiveModel categoryModel,
  );
  Future<ProductCategoryHiveModel?> getProductCategoryById(String id);
  Future<List<ProductCategoryHiveModel>> getAllProductCategories();
  Future<List<ProductCategoryHiveModel>> getProductCategoriesByShopId(
    String shopId,
  );
  Future<bool> updateProductCategory(
    String id,
    ProductCategoryHiveModel categoryModel,
  );
  Future<bool> deleteProductCategory(String id);
  Future<void> deleteAllProductCategories();
}
