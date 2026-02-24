import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/shop/data/repositories/shop_repository.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';

final getAllShopsOfUserUsecaseProvider = Provider<GetAllShopsOfUserUsecase>((
  ref,
) {
  final shopRepository = ref.read(shopRepositoryProvider);
  return GetAllShopsOfUserUsecase(shopRepository: shopRepository);
});

class GetAllShopsOfUserUsecase
    implements UsecaseWithoutParms<List<ShopEntity>> {
  final IShopRepository _shopRepository;

  GetAllShopsOfUserUsecase({required IShopRepository shopRepository})
    : _shopRepository = shopRepository;

  @override
  Future<Either<Failure, List<ShopEntity>>> call() {
    return _shopRepository.getAllShopsOfAUser();
  }
}
