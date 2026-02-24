import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/usecases/create_shop_usecase.dart';
import 'package:resub/features/shop/domain/usecases/delete_shop_usecase.dart';
import 'package:resub/features/shop/domain/usecases/get_all_shops_of_user_usecase.dart';
import 'package:resub/features/shop/domain/usecases/get_all_shops_usecase.dart';
import 'package:resub/features/shop/domain/usecases/get_shop_by_id_usecase.dart';
import 'package:resub/features/shop/domain/usecases/update_shop_usecase.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';

final shopViewModelProvider = NotifierProvider<ShopViewModel, ShopState>(
  () => ShopViewModel(),
);

class ShopViewModel extends Notifier<ShopState> {
  late final CreateShopUsecase _createShopUsecase;
  late final DeleteShopUsecase _deleteShopUsecase;
  late final GetShopByIdUsecase _getShopByIdUsecase;
  late final GetAllShopsUsecase _getAllShopsUsecase;
  late final GetAllShopsOfUserUsecase _getAllShopsOfUserUsecase;
  late final UpdateShopUsecase _updateShopUsecase;

  @override
  build() {
    _createShopUsecase = ref.read(createShopUsecaseProvider);
    _deleteShopUsecase = ref.read(deleteShopUsecaseProvider);
    _getShopByIdUsecase = ref.read(getShopByIdUsecaseProvider);
    _getAllShopsUsecase = ref.read(getAllShopsUsecaseProvider);
    _getAllShopsOfUserUsecase = ref.read(getAllShopsOfUserUsecaseProvider);
    _updateShopUsecase = ref.read(updateShopUsecaseProvider);
    return const ShopState();
  }

  Future<void> createShop({required ShopEntity shopEntity}) async {
    state = state.copyWith(status: ShopStatus.loading);
    final params = CreateShopUsecaseParams(shopEntity: shopEntity);
    final result = await _createShopUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ShopStatus.error,
          errorMessage: failure.message,
        );
      },
      (shop) {
        state = state.copyWith(status: ShopStatus.created, shop: shop);
      },
    );
  }

  Future<void> getShopById({required String shopId}) async {
    state = state.copyWith(status: ShopStatus.loading);
    final params = GetShopByIdUsecaseParams(shopId: shopId);
    final result = await _getShopByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ShopStatus.error,
          errorMessage: failure.message,
        );
      },
      (shop) {
        state = state.copyWith(status: ShopStatus.loaded, shop: shop);
      },
    );
  }

  Future<void> getAllShops() async {
    state = state.copyWith(status: ShopStatus.loading);
    final result = await _getAllShopsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ShopStatus.error,
          errorMessage: failure.message,
        );
      },
      (shops) {
        state = state.copyWith(status: ShopStatus.loaded, shops: shops);
      },
    );
  }

  Future<void> getAllShopsOfUser() async {
    state = state.copyWith(status: ShopStatus.loading);
    final result = await _getAllShopsOfUserUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ShopStatus.error,
          errorMessage: failure.message,
        );
      },
      (shops) {
        state = state.copyWith(status: ShopStatus.loaded, shops: shops);
      },
    );
  }

  Future<void> updateShop({
    required String shopId,
    required ShopEntity shopEntity,
  }) async {
    state = state.copyWith(status: ShopStatus.loading);
    final params = UpdateShopUsecaseParams(
      shopId: shopId,
      shopEntity: shopEntity,
    );
    final result = await _updateShopUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ShopStatus.error,
          errorMessage: failure.message,
        );
      },
      (shop) {
        state = state.copyWith(status: ShopStatus.updated, shop: shop);
      },
    );
  }

  Future<void> deleteShop({required String shopId}) async {
    state = state.copyWith(status: ShopStatus.loading);
    final params = DeleteShopUsecaseParams(shopId: shopId);
    final result = await _deleteShopUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ShopStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          state = state.copyWith(status: ShopStatus.deleted);
        } else {
          state = state.copyWith(
            status: ShopStatus.error,
            errorMessage: 'Shop deletion failed',
          );
        }
      },
    );
  }
}
