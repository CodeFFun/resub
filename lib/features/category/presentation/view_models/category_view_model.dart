import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/usecases/create_category_usecase.dart';
import 'package:resub/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:resub/features/category/domain/usecases/get_categories_by_shop_usecase.dart';
import 'package:resub/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:resub/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:resub/features/category/domain/usecases/get_shop_category_usecase.dart';
import 'package:resub/features/category/domain/usecases/update_category_usecase.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';

final categoryViewModelProvider =
    NotifierProvider<CategoryViewModel, CategoryState>(
      () => CategoryViewModel(),
    );

class CategoryViewModel extends Notifier<CategoryState> {
  late final CreateProductCategoryUsecase _createProductCategoryUsecase;
  late final DeleteProductCategoryUsecase _deleteProductCategoryUsecase;
  late final GetProductCategoryByIdUsecase _getProductCategoryByIdUsecase;
  late final GetAllProductCategoriesUsecase _getAllProductCategoriesUsecase;
  late final GetProductCategoriesByShopIdUsecase
  _getProductCategoriesByShopIdUsecase;
  late final UpdateProductCategoryUsecase _updateProductCategoryUsecase;
  late final GetAllShopCategoriesUsecase _getAllShopCategoriesUsecase;

  @override
  build() {
    _createProductCategoryUsecase = ref.read(
      createProductCategoryUsecaseProvider,
    );
    _deleteProductCategoryUsecase = ref.read(
      deleteProductCategoryUsecaseProvider,
    );
    _getProductCategoryByIdUsecase = ref.read(
      getProductCategoryByIdUsecaseProvider,
    );
    _getAllProductCategoriesUsecase = ref.read(
      getAllProductCategoriesUsecaseProvider,
    );
    _getProductCategoriesByShopIdUsecase = ref.read(
      getProductCategoriesByShopIdUsecaseProvider,
    );
    _updateProductCategoryUsecase = ref.read(
      updateProductCategoryUsecaseProvider,
    );
    _getAllShopCategoriesUsecase = ref.read(
      getAllShopCategoriesUsecaseProvider,
    );
    return const CategoryState();
  }

  Future<void> createCategory({required CategoryEntity categoryEntity}) async {
    state = state.copyWith(status: CategoryStatus.loading);
    final params = CreateProductCategoryUsecaseParams(
      categoryEntity: categoryEntity,
    );
    final result = await _createProductCategoryUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (category) {
        state = state.copyWith(
          status: CategoryStatus.created,
          category: category,
        );
      },
    );
  }

  Future<void> getCategoryById({required String categoryId}) async {
    state = state.copyWith(status: CategoryStatus.loading);
    final params = GetProductCategoryByIdUsecaseParams(categoryId: categoryId);
    final result = await _getProductCategoryByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (category) {
        if (category != null) {
          state = state.copyWith(
            status: CategoryStatus.loaded,
            category: category,
          );
        } else {
          state = state.copyWith(
            status: CategoryStatus.error,
            errorMessage: 'Category not found',
          );
        }
      },
    );
  }

  Future<void> getAllCategories() async {
    state = state.copyWith(status: CategoryStatus.loading);
    final result = await _getAllProductCategoriesUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        );
      },
    );
  }

  Future<void> getCategoriesByShopId({required String shopId}) async {
    state = state.copyWith(status: CategoryStatus.loading);
    final params = GetProductCategoriesByShopIdUsecaseParams(shopId: shopId);
    final result = await _getProductCategoriesByShopIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        );
      },
    );
  }

  Future<void> updateCategory({
    required String categoryId,
    required CategoryEntity categoryEntity,
  }) async {
    state = state.copyWith(status: CategoryStatus.loading);
    final params = UpdateProductCategoryUsecaseParams(
      categoryId: categoryId,
      categoryEntity: categoryEntity,
    );
    final result = await _updateProductCategoryUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (category) {
        if (category != null) {
          state = state.copyWith(
            status: CategoryStatus.updated,
            category: category,
          );
        } else {
          state = state.copyWith(
            status: CategoryStatus.error,
            errorMessage: 'Category update failed',
          );
        }
      },
    );
  }

  Future<void> deleteCategory({required String categoryId}) async {
    state = state.copyWith(status: CategoryStatus.loading);
    final params = DeleteProductCategoryUsecaseParams(categoryId: categoryId);
    final result = await _deleteProductCategoryUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          state = state.copyWith(status: CategoryStatus.deleted);
        } else {
          state = state.copyWith(
            status: CategoryStatus.error,
            errorMessage: 'Category deletion failed',
          );
        }
      },
    );
  }

  Future<void> getAllShopCategories() async {
    state = state.copyWith(status: CategoryStatus.loading);
    final result = await _getAllShopCategoriesUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        );
      },
    );
  }
}
