import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/address/data/repositories/address_repository.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';

class CreateAddressUsecaseParams extends Equatable {
  final AddressEntity addressEntity;

  const CreateAddressUsecaseParams({required this.addressEntity});

  @override
  List<Object?> get props => [addressEntity];
}

final createAddressUsecaseProvider = Provider<CreateAddressUsecase>((ref) {
  final addressRepository = ref.read(addressRepositoryProvider);
  return CreateAddressUsecase(addressRepository: addressRepository);
});

class CreateAddressUsecase
    implements UsecaseWithParms<AddressEntity, CreateAddressUsecaseParams> {
  final IAddressRepository _addressRepository;

  CreateAddressUsecase({required IAddressRepository addressRepository})
    : _addressRepository = addressRepository;

  @override
  Future<Either<Failure, AddressEntity>> call(
    CreateAddressUsecaseParams params,
  ) {
    return _addressRepository.createAddress(params.addressEntity);
  }
}
