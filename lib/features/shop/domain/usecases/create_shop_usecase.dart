import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/shop/data/repositories/shop_repository.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';

class CreateShopUsecaseParams extends Equatable {
  final ShopEntity shopEntity;

  const CreateShopUsecaseParams({required this.shopEntity});

  @override
  List<Object?> get props => [shopEntity];
}

final createShopUsecaseProvider = Provider<CreateShopUsecase>((ref) {
  final shopRepository = ref.read(shopRepositoryProvider);
  return CreateShopUsecase(shopRepository: shopRepository);
});

class CreateShopUsecase
    implements UsecaseWithParms<ShopEntity, CreateShopUsecaseParams> {
  final IShopRepository _shopRepository;

  CreateShopUsecase({required IShopRepository shopRepository})
    : _shopRepository = shopRepository;

  @override
  Future<Either<Failure, ShopEntity>> call(CreateShopUsecaseParams params) {
    return _shopRepository.createShop(params.shopEntity);
  }
}
