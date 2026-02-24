import 'package:resub/features/shop/data/models/shop_model.dart';

abstract interface class IShopRemoteDatasource {
  Future<ShopApiModel> getShopById(String id);
  Future<ShopApiModel> createShop(ShopApiModel shopModel);
  Future<List<ShopApiModel>> getAllShopsOfAUser();
  Future<List<ShopApiModel>> getAllShops();
  Future<ShopApiModel> updateShop(
    String id,
    ShopApiModel shopModel,
  );
  Future<bool> deleteShop(String id);
}
