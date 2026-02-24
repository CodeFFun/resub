import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

abstract interface class IShopRepository {
  Future<Either<Failure, ShopEntity>> getShopById(String id);
  Future<Either<Failure, ShopEntity>> createShop(ShopEntity shopEntity);
  Future<Either<Failure, List<ShopEntity>>> getAllShopsOfAUser();
  Future<Either<Failure, List<ShopEntity>>> getAllShops();
  Future<Either<Failure, ShopEntity>> updateShop(
    String id,
    ShopEntity shopEntity,
  );
  Future<Either<Failure, bool>> deleteShop(String id);
}
