import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/shop/data/repositories/shop_repository.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';

class DeleteShopUsecaseParams extends Equatable {
  final String shopId;

  const DeleteShopUsecaseParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final deleteShopUsecaseProvider = Provider<DeleteShopUsecase>((ref) {
  final shopRepository = ref.read(shopRepositoryProvider);
  return DeleteShopUsecase(shopRepository: shopRepository);
});

class DeleteShopUsecase
    implements UsecaseWithParms<bool, DeleteShopUsecaseParams> {
  final IShopRepository _shopRepository;

  DeleteShopUsecase({required IShopRepository shopRepository})
    : _shopRepository = shopRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteShopUsecaseParams params) {
    return _shopRepository.deleteShop(params.shopId);
  }
}
