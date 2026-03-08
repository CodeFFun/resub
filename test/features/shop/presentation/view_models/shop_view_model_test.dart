import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/shop/data/repositories/shop_repository.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';

class _FakeShopRepository implements IShopRepository {
  @override
  Future<Either<Failure, ShopEntity>> getShopById(String id) async {
    return const Right(ShopEntity(id: 'shop-1', name: 'MilkHub'));
  }

  @override
  Future<Either<Failure, ShopEntity>> createShop(ShopEntity shopEntity) async {
    return Right(shopEntity.copyWith(id: 'created-shop'));
  }

  @override
  Future<Either<Failure, List<ShopEntity>>> getAllShopsOfAUser() async {
    return const Right([ShopEntity(id: 'shop-1')]);
  }

  @override
  Future<Either<Failure, List<ShopEntity>>> getAllShops() async {
    return const Right([ShopEntity(id: 'shop-2')]);
  }

  @override
  Future<Either<Failure, ShopEntity>> updateShop(
    String id,
    ShopEntity shopEntity,
  ) async {
    return Right(shopEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteShop(String id) async {
    return const Right(true);
  }
}

void main() {
  late ProviderContainer container;
  late ShopViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        shopRepositoryProvider.overrideWithValue(_FakeShopRepository()),
      ],
    );
    viewModel = container.read(shopViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getShopById sets loaded state with shop', () async {
      await viewModel.getShopById(shopId: 'shop-1');

      final state = container.read(shopViewModelProvider);
      expect(state.status, ShopStatus.loaded);
      expect(state.shop?.name, 'MilkHub');
    });
  });

  group('other methods', () {
    test('createShop sets created state', () async {
      await viewModel.createShop(
        shopEntity: const ShopEntity(name: 'Fresh Store'),
      );

      final state = container.read(shopViewModelProvider);
      expect(state.status, ShopStatus.created);
      expect(state.shop?.id, 'created-shop');
    });
  });
}
