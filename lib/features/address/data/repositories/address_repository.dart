import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/address/data/datasources/address_datasource.dart';
import 'package:resub/features/address/data/datasources/remote/address_remote_datasource.dart';
import 'package:resub/features/address/data/models/address_model.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';

final addressRepositoryProvider = Provider<IAddressRepository>((ref) {
  final addressRemoteDatasource = ref.read(addressRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AddressRepository(
    addressRemoteDatasource: addressRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AddressRepository implements IAddressRepository {
  final NetworkInfo _networkInfo;
  final IAddressRemoteDatasource _addressRemoteDatasource;

  AddressRepository({
    required NetworkInfo networkInfo,
    required IAddressRemoteDatasource addressRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _addressRemoteDatasource = addressRemoteDatasource;

  @override
  Future<Either<Failure, AddressEntity>> createAddress(
    AddressEntity addressEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AddressApiModel.fromEntity(addressEntity);
        final model = await _addressRemoteDatasource.createAddress(apiModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAddress(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _addressRemoteDatasource.deleteAddress(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> getAddressById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _addressRemoteDatasource.getAddressById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAllAddressesOfAUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _addressRemoteDatasource.getAllAddressesOfAUser();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(
    String id,
    AddressEntity addressEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AddressApiModel.fromEntity(addressEntity);
        final model = await _addressRemoteDatasource.updateAddress(
          id,
          apiModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
