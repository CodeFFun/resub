import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/address/data/repositories/address_repository.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';

final getAddressOfUserUsecaseProvider = Provider<GetAddressOfUserUsecase>((
  ref,
) {
  final addressRepository = ref.read(addressRepositoryProvider);
  return GetAddressOfUserUsecase(addressRepository: addressRepository);
});

class GetAddressOfUserUsecase
    implements UsecaseWithoutParms<List<AddressEntity>> {
  final IAddressRepository _addressRepository;

  GetAddressOfUserUsecase({required IAddressRepository addressRepository})
    : _addressRepository = addressRepository;

  @override
  Future<Either<Failure, List<AddressEntity>>> call() {
    return _addressRepository.getAllAddressesOfAUser();
  }
}
