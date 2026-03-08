import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/address/data/datasources/address_datasource.dart';
import 'package:resub/features/address/data/models/address_hive_model.dart';

final addressLocalDatasourceProvider = Provider<IAddressLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AddressLocalDatasource(hiveService: hiveService);
});

class AddressLocalDatasource implements IAddressLocalDatasource {
  final HiveService _hiveService;

  AddressLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<AddressHiveModel> createAddress(AddressHiveModel addressModel) async {
    try {
      final value = await _hiveService.createAddress(addressModel);
      return Future.value(value);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> deleteAddress(String id) async {
    try {
      await _hiveService.deleteAddress(id);
      return Future.value(true);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> deleteAllAddresses() async {
    return await _hiveService.deleteAllAddresses();
  }

  @override
  Future<List<AddressHiveModel>> getAllAddressOfAUser(String userId) async {
    try {
      final value =  _hiveService.getAllAddressOfAUser(userId);
      return Future.value(value);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<AddressHiveModel?> getAddressById(String id) async {
    try {
      final value =  _hiveService.getAddressById(id);
      return Future.value(value);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> updateAddress(String id, AddressHiveModel addressModel) async {
    try {
      final value = await _hiveService.updateAddress(id, addressModel);
      return Future.value(value);
    } catch (e) {
      return Future.error(e);
    }
  }
}
