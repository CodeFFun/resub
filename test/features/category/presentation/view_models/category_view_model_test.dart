import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/category/data/repositories/category_repository.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';

class _FakeCategoryRepository implements ICategoryRepository {
  @override
  Future<Either<Failure, CategoryEntity?>> getProductCategoryById(
    String id,
  ) async {
    return const Right(CategoryEntity(id: 'c1', name: 'Dairy'));
  }

  @override
  Future<Either<Failure, CategoryEntity>> createProductCategory(
    CategoryEntity categoryEntity,
  ) async {
    return Right(categoryEntity.copyWith(id: 'created-c1'));
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>>
  getAllProductCategories() async {
    return const Right([CategoryEntity(id: 'c1')]);
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllShopCategories() async {
    return const Right([CategoryEntity(id: 's1')]);
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllProductCategoriesByShopId(
    String shopId,
  ) async {
    return const Right([CategoryEntity(id: 'by-shop')]);
  }

  @override
  Future<Either<Failure, CategoryEntity?>> updateProductCategory(
    String id,
    CategoryEntity categoryEntity,
  ) async {
    return Right(categoryEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteProductCategory(String id) async {
    return const Right(true);
  }
}

void main() {
  late ProviderContainer container;
  late CategoryViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        categoryRepositoryProvider.overrideWithValue(_FakeCategoryRepository()),
      ],
    );
    viewModel = container.read(categoryViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getCategoryById sets loaded state with category', () async {
      await viewModel.getCategoryById(categoryId: 'c1');

      final state = container.read(categoryViewModelProvider);
      expect(state.status, CategoryStatus.loaded);
      expect(state.category?.name, 'Dairy');
    });
  });

  group('other methods', () {
    test('createCategory sets created state', () async {
      await viewModel.createCategory(
        categoryEntity: const CategoryEntity(name: 'New Category'),
      );

      final state = container.read(categoryViewModelProvider);
      expect(state.status, CategoryStatus.created);
      expect(state.category?.id, 'created-c1');
    });
  });
}
