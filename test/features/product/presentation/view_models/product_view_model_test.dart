import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/product/data/repositories/product_repository.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/repositories/product_repository.dart';
import 'package:resub/features/product/presentation/state/product_state.dart';
import 'package:resub/features/product/presentation/view_models/product_view_model.dart';

class _FakeProductRepository implements IProductRepository {
  @override
  Future<Either<Failure, ProductEntity?>> getProductById(String id) async {
    return const Right(
      ProductEntity(
        id: 'p1',
        name: 'Yogurt',
        description: 'Plain yogurt',
        basePrice: 50,
        stockQuantity: 20,
        discount: 0,
        shopIds: ['shop-1'],
        categoryId: 'cat-1',
      ),
    );
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct(
    String shopId,
    ProductEntity productEntity,
  ) async {
    return Right(productEntity.copyWith(id: 'created-p1'));
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByShopId(
    String shopId,
  ) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, ProductEntity?>> updateProduct(
    String id,
    ProductEntity productEntity,
  ) async {
    return Right(productEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    return const Right(true);
  }
}

void main() {
  late ProviderContainer container;
  late ProductViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      ],
    );
    viewModel = container.read(productViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getProductById sets loaded state with product', () async {
      await viewModel.getProductById(productId: 'p1');

      final state = container.read(productViewModelProvider);
      expect(state.status, ProductStatus.loaded);
      expect(state.product?.name, 'Yogurt');
    });
  });

  group('other methods', () {
    test('createProduct sets created state', () async {
      await viewModel.createProduct(
        shopId: 'shop-1',
        productEntity: const ProductEntity(
          name: 'Cheese',
          description: 'Cheddar',
          basePrice: 120,
          stockQuantity: 8,
          discount: 0,
          shopIds: ['shop-1'],
          categoryId: 'cat-1',
        ),
      );

      final state = container.read(productViewModelProvider);
      expect(state.status, ProductStatus.created);
      expect(state.product?.id, 'created-p1');
    });
  });
}
