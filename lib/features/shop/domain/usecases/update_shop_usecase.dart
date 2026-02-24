import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/shop/data/repositories/shop_repository.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';

class UpdateShopUsecaseParams extends Equatable {
  final String shopId;
  final ShopEntity shopEntity;

  const UpdateShopUsecaseParams({
    required this.shopId,
    required this.shopEntity,
  });

  @override
  List<Object?> get props => [shopId, shopEntity];
}

final updateShopUsecaseProvider = Provider<UpdateShopUsecase>((ref) {
  final shopRepository = ref.read(shopRepositoryProvider);
  return UpdateShopUsecase(shopRepository: shopRepository);
});

class UpdateShopUsecase
    implements UsecaseWithParms<ShopEntity, UpdateShopUsecaseParams> {
  final IShopRepository _shopRepository;

  UpdateShopUsecase({required IShopRepository shopRepository})
    : _shopRepository = shopRepository;

  @override
  Future<Either<Failure, ShopEntity>> call(UpdateShopUsecaseParams params) {
    return _shopRepository.updateShop(params.shopId, params.shopEntity);
  }
}
