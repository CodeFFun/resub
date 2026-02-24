import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/shop/data/repositories/shop_repository.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';

class GetShopByIdUsecaseParams extends Equatable {
  final String shopId;

  const GetShopByIdUsecaseParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getShopByIdUsecaseProvider = Provider<GetShopByIdUsecase>((ref) {
  final shopRepository = ref.read(shopRepositoryProvider);
  return GetShopByIdUsecase(shopRepository: shopRepository);
});

class GetShopByIdUsecase
    implements UsecaseWithParms<ShopEntity, GetShopByIdUsecaseParams> {
  final IShopRepository _shopRepository;

  GetShopByIdUsecase({required IShopRepository shopRepository})
    : _shopRepository = shopRepository;

  @override
  Future<Either<Failure, ShopEntity>> call(GetShopByIdUsecaseParams params) {
    return _shopRepository.getShopById(params.shopId);
  }
}
