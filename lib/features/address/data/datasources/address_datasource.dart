import 'package:resub/features/address/data/models/address_model.dart';

abstract interface class IAddressRemoteDatasource {
  Future<AddressApiModel> getAddressById(String id);
  Future<AddressApiModel> createAddress(AddressApiModel addressModel);
  Future<List<AddressApiModel>> getAllAddressesOfAUser();
  Future<AddressApiModel> updateAddress(
    String id,
    AddressApiModel addressModel,
  );
  Future<bool> deleteAddress(String id);
}
