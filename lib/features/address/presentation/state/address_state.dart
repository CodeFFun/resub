import 'package:equatable/equatable.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';

enum AddressStatus {
  initial,
  loading,
  created,
  updated,
  deleted,
  error,
  loaded,
}

class AddressState extends Equatable {
  final AddressStatus? status;
  final AddressEntity? address;
  final List<AddressEntity>? addresses;
  final String? errorMessage;

  const AddressState({
    this.status,
    this.address,
    this.addresses,
    this.errorMessage,
  });

  AddressState copyWith({
    AddressStatus? status,
    AddressEntity? address,
    List<AddressEntity>? addresses,
    String? errorMessage,
  }) {
    return AddressState(
      status: status ?? this.status,
      address: address ?? this.address,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, address, addresses, errorMessage];
}
