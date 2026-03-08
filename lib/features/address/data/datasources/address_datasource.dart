import 'package:resub/features/address/data/models/address_model.dart';
import 'package:resub/features/address/data/models/address_hive_model.dart';

// Remote Datasource Interface
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

// Local Datasource Interface
abstract interface class IAddressLocalDatasource {
  Future<AddressHiveModel?> getAddressById(String id);
  Future<AddressHiveModel> createAddress(AddressHiveModel addressModel);
  Future<List<AddressHiveModel>> getAllAddressOfAUser(String userId);
  Future<bool> updateAddress(String id, AddressHiveModel addressModel);
  Future<bool> deleteAddress(String id);
  Future<void> deleteAllAddresses();
}
