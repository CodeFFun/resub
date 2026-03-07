import 'package:resub/features/shop/data/models/shop_model.dart';
import 'package:resub/features/shop/data/models/shop_hive_model.dart';

// Remote Datasource Interface
abstract interface class IShopRemoteDatasource {
  Future<ShopApiModel> getShopById(String id);
  Future<ShopApiModel> createShop(ShopApiModel shopModel);
  Future<List<ShopApiModel>> getAllShopsOfAUser();
  Future<List<ShopApiModel>> getAllShops();
  Future<ShopApiModel> updateShop(String id, ShopApiModel shopModel);
  Future<bool> deleteShop(String id);
}

// Local Datasource Interface
abstract interface class IShopLocalDatasource {
  Future<ShopHiveModel> createShop(ShopHiveModel shopModel);
  Future<ShopHiveModel?> getShopById(String id);
  Future<List<ShopHiveModel>> getAllShops();
  Future<List<ShopHiveModel>> getShopsByUserId(String userId);
  Future<List<ShopHiveModel>> getShopsByCategoryId(String categoryId);
  Future<bool> updateShop(String id, ShopHiveModel shopModel);
  Future<bool> deleteShop(String id);
  Future<void> deleteAllShops();
}
