import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/usecases/create_address_usecase.dart';
import 'package:resub/features/address/domain/usecases/delete_address_usecase.dart';
import 'package:resub/features/address/domain/usecases/get_address_by_id_usecase.dart';
import 'package:resub/features/address/domain/usecases/get_address_of_user_usecase.dart';
import 'package:resub/features/address/domain/usecases/update_address_usecase.dart';
import 'package:resub/features/address/presentation/state/address_state.dart';

final addressViewModelProvider =
    NotifierProvider<AddressViewModel, AddressState>(() => AddressViewModel());

class AddressViewModel extends Notifier<AddressState> {
  late final CreateAddressUsecase _createAddressUsecase;
  late final DeleteAddressUsecase _deleteAddressUsecase;
  late final GetAddressByIdUsecase _getAddressByIdUsecase;
  late final GetAddressOfUserUsecase _getAddressOfUserUsecase;
  late final UpdateAddressUsecase _updateAddressUsecase;

  @override
  build() {
    _createAddressUsecase = ref.read(createAddressUsecaseProvider);
    _deleteAddressUsecase = ref.read(deleteAddressUsecaseProvider);
    _getAddressByIdUsecase = ref.read(getAddressByIdUsecaseProvider);
    _getAddressOfUserUsecase = ref.read(getAddressOfUserUsecaseProvider);
    _updateAddressUsecase = ref.read(updateAddressUsecaseProvider);
    return AddressState();
  }

  Future<void> createAddress({required AddressEntity addressEntity}) async {
    state = state.copyWith(status: AddressStatus.loading);
    final params = CreateAddressUsecaseParams(addressEntity: addressEntity);
    final result = await _createAddressUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        );
      },
      (address) {
        state = state.copyWith(status: AddressStatus.created, address: address);
      },
    );
  }

  Future<void> getAddressById({required String addressId}) async {
    state = state.copyWith(status: AddressStatus.loading);
    final params = GetAddressByIdUsecaseParams(addressId: addressId);
    final result = await _getAddressByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        );
      },
      (address) {
        state = state.copyWith(status: AddressStatus.loaded, address: address);
      },
    );
  }

  Future<void> getAddressesOfUser() async {
    state = state.copyWith(status: AddressStatus.loading);
    final result = await _getAddressOfUserUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        );
      },
      (addresses) {
        state = state.copyWith(
          status: AddressStatus.loaded,
          addresses: addresses,
        );
      },
    );
  }

  Future<void> updateAddress({
    required String addressId,
    required AddressEntity addressEntity,
  }) async {
    state = state.copyWith(status: AddressStatus.loading);
    final params = UpdateAddressUsecaseParams(
      addressId: addressId,
      addressEntity: addressEntity,
    );
    final result = await _updateAddressUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        );
      },
      (address) {
        state = state.copyWith(status: AddressStatus.updated, address: address);
      },
    );
  }

  Future<void> deleteAddress({required String addressId}) async {
    state = state.copyWith(status: AddressStatus.loading);
    final params = DeleteAddressUsecaseParams(addressId: addressId);
    final result = await _deleteAddressUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          state = state.copyWith(status: AddressStatus.deleted);
        } else {
          state = state.copyWith(
            status: AddressStatus.error,
            errorMessage: 'Address deletion failed',
          );
        }
      },
    );
  }
}
