import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/address/data/repositories/address_repository.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';

class UpdateAddressUsecaseParams extends Equatable {
	final String addressId;
	final AddressEntity addressEntity;

	const UpdateAddressUsecaseParams({
		required this.addressId,
		required this.addressEntity,
	});

	@override
	List<Object?> get props => [addressId, addressEntity];
}

final updateAddressUsecaseProvider = Provider<UpdateAddressUsecase>((ref) {
	final addressRepository = ref.read(addressRepositoryProvider);
	return UpdateAddressUsecase(addressRepository: addressRepository);
});

class UpdateAddressUsecase
		implements UsecaseWithParms<AddressEntity, UpdateAddressUsecaseParams> {
	final IAddressRepository _addressRepository;

	UpdateAddressUsecase({required IAddressRepository addressRepository})
			: _addressRepository = addressRepository;

	@override
	Future<Either<Failure, AddressEntity>> call(
		UpdateAddressUsecaseParams params,
	) {
		return _addressRepository.updateAddress(
			params.addressId,
			params.addressEntity,
		);
	}
}
