import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/usecases/create_product_usecase.dart';
import 'package:resub/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:resub/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:resub/features/product/domain/usecases/get_products_by_shop_id_usecase.dart';
import 'package:resub/features/product/domain/usecases/update_product_usecase.dart';
import 'package:resub/features/product/presentation/state/product_state.dart';

final productViewModelProvider =
    NotifierProvider<ProductViewModel, ProductState>(() => ProductViewModel());

class ProductViewModel extends Notifier<ProductState> {
  late final CreateProductUsecase _createProductUsecase;
  late final DeleteProductUsecase _deleteProductUsecase;
  late final GetProductByIdUsecase _getProductByIdUsecase;
  late final GetProductsByShopIdUsecase _getProductsByShopIdUsecase;
  late final UpdateProductUsecase _updateProductUsecase;

  @override
  build() {
    _createProductUsecase = ref.read(createProductUsecaseProvider);
    _deleteProductUsecase = ref.read(deleteProductUsecaseProvider);
    _getProductByIdUsecase = ref.read(getProductByIdUsecaseProvider);
    _getProductsByShopIdUsecase = ref.read(getProductsByShopIdUsecaseProvider);
    _updateProductUsecase = ref.read(updateProductUsecaseProvider);
    return const ProductState();
  }

  Future<void> createProduct({
    required String shopId,
    required ProductEntity productEntity,
  }) async {
    state = state.copyWith(status: ProductStatus.loading);
    final params = CreateProductUsecaseParams(
      shopId: shopId,
      productEntity: productEntity,
    );
    final result = await _createProductUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (product) {
        state = state.copyWith(status: ProductStatus.created, product: product);
      },
    );
  }

  Future<void> getProductById({required String productId}) async {
    state = state.copyWith(status: ProductStatus.loading);
    final params = GetProductByIdUsecaseParams(productId: productId);
    final result = await _getProductByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (product) {
        state = state.copyWith(status: ProductStatus.loaded, product: product);
      },
    );
  }

  Future<void> getProductsByShopId({required String shopId}) async {
    state = state.copyWith(status: ProductStatus.loading);
    final params = GetProductsByShopIdUsecaseParams(shopId: shopId);
    final result = await _getProductsByShopIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          status: ProductStatus.loaded,
          products: products,
        );
      },
    );
  }

  Future<void> updateProduct({
    required String productId,
    required ProductEntity productEntity,
  }) async {
    state = state.copyWith(status: ProductStatus.loading);
    final params = UpdateProductUsecaseParams(
      productId: productId,
      productEntity: productEntity,
    );
    final result = await _updateProductUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (product) {
        state = state.copyWith(status: ProductStatus.updated, product: product);
      },
    );
  }

  Future<void> deleteProduct({required String productId}) async {
    state = state.copyWith(status: ProductStatus.loading);
    final params = DeleteProductUsecaseParams(productId: productId);
    final result = await _deleteProductUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          state = state.copyWith(status: ProductStatus.deleted);
        } else {
          state = state.copyWith(
            status: ProductStatus.error,
            errorMessage: 'Product deletion failed',
          );
        }
      },
    );
  }
}
