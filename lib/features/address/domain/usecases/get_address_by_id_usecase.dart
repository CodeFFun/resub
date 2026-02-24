import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/address/data/repositories/address_repository.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';

class GetAddressByIdUsecaseParams extends Equatable {
  final String addressId;

  const GetAddressByIdUsecaseParams({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

final getAddressByIdUsecaseProvider = Provider<GetAddressByIdUsecase>((ref) {
  final addressRepository = ref.read(addressRepositoryProvider);
  return GetAddressByIdUsecase(addressRepository: addressRepository);
});

class GetAddressByIdUsecase
    implements UsecaseWithParms<AddressEntity, GetAddressByIdUsecaseParams> {
  final IAddressRepository _addressRepository;

  GetAddressByIdUsecase({required IAddressRepository addressRepository})
    : _addressRepository = addressRepository;

  @override
  Future<Either<Failure, AddressEntity>> call(
    GetAddressByIdUsecaseParams params,
  ) {
    return _addressRepository.getAddressById(params.addressId);
  }
}
