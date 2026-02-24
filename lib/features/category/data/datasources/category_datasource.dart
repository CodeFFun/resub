import 'package:resub/features/category/data/models/category_model.dart';

abstract interface class ICategoryRemoteDatasource {
  Future<CategoryApiModel> createProductCategory(
    CategoryApiModel categoryModel,
  );
  Future<CategoryApiModel?> getProductCategoryById(String id);
  Future<List<CategoryApiModel>> getAllProductCategories();
  Future<List<CategoryApiModel>> getAllProductCategoriesByShopId(String shopId);
  Future<CategoryApiModel?> updateProductCategory(
    String id,
    CategoryApiModel categoryModel,
  );
  Future<bool> deleteProductCategory(String id);
}
