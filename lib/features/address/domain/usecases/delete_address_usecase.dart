import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/address/data/repositories/address_repository.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';

class DeleteAddressUsecaseParams extends Equatable {
	final String addressId;

	const DeleteAddressUsecaseParams({required this.addressId});

	@override
	List<Object?> get props => [addressId];
}

final deleteAddressUsecaseProvider = Provider<DeleteAddressUsecase>((ref) {
	final addressRepository = ref.read(addressRepositoryProvider);
	return DeleteAddressUsecase(addressRepository: addressRepository);
});

class DeleteAddressUsecase
		implements UsecaseWithParms<bool, DeleteAddressUsecaseParams> {
	final IAddressRepository _addressRepository;

	DeleteAddressUsecase({required IAddressRepository addressRepository})
			: _addressRepository = addressRepository;

	@override
	Future<Either<Failure, bool>> call(DeleteAddressUsecaseParams params) {
		return _addressRepository.deleteAddress(params.addressId);
	}
}
