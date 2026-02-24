import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';

abstract interface class IProductRepository {
  Future<Either<Failure, ProductEntity>> createProduct(
    String shopId,
    ProductEntity productEntity,
  );
  Future<Either<Failure, ProductEntity?>> getProductById(String id);
  Future<Either<Failure, List<ProductEntity>>> getProductsByShopId(
    String shopId,
  );
  Future<Either<Failure, ProductEntity?>> updateProduct(
    String id,
    ProductEntity productEntity,
  );
  Future<Either<Failure, bool>> deleteProduct(String id);
}
