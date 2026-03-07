import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/address/data/datasources/address_datasource.dart';
import 'package:resub/features/address/data/datasources/local/address_local_datasource.dart';
import 'package:resub/features/address/data/datasources/remote/address_remote_datasource.dart';
import 'package:resub/features/address/data/models/address_hive_model.dart';
import 'package:resub/features/address/data/models/address_model.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';

final addressRepositoryProvider = Provider<IAddressRepository>((ref) {
  final addressRemoteDatasource = ref.read(addressRemoteDatasourceProvider);
  final addressLocalDatasource = ref.read(addressLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return AddressRepository(
    addressRemoteDatasource: addressRemoteDatasource,
    addressLocalDatasource: addressLocalDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class AddressRepository implements IAddressRepository {
  final NetworkInfo _networkInfo;
  final IAddressRemoteDatasource _addressRemoteDatasource;
  final IAddressLocalDatasource _addressLocalDatasource;
  final UserSessionService _userSession;

  AddressRepository({
    required NetworkInfo networkInfo,
    required IAddressRemoteDatasource addressRemoteDatasource,
    required IAddressLocalDatasource addressLocalDatasource,
    required UserSessionService userSession,
  }) : _networkInfo = networkInfo,
       _addressRemoteDatasource = addressRemoteDatasource,
       _addressLocalDatasource = addressLocalDatasource,
       _userSession = userSession;

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
      try {
        final userId = _userSession.getCurrentUserId();
        if (userId == null) {
          return const Left(ApiFailure(message: 'User not logged in'));
        }
        final hiveModel = AddressHiveModel.fromEntity(
          addressEntity,
          userId: userId,
        );
        final model = await _addressLocalDatasource.createAddress(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
      try {
        final result = await _addressLocalDatasource.deleteAddress(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
      try {
        final model = await _addressLocalDatasource.getAddressById(id);
        if (model == null) {
          return const Left(LocalDatabaseFailure(message: 'Address not found'));
        }
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
      try {
        final userId = _userSession.getCurrentUserId();
        if (userId == null) {
          return const Left(ApiFailure(message: 'User not logged in'));
        }
        final models = await _addressLocalDatasource.getAllAddressOfAUser(
          userId,
        );
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
      try {
        final userId = _userSession.getCurrentUserId();
        if (userId == null) {
          return const Left(ApiFailure(message: 'User not logged in'));
        }
        final hiveModel = AddressHiveModel.fromEntity(
          addressEntity,
          userId: userId,
        );
        final result = await _addressLocalDatasource.updateAddress(
          id,
          hiveModel,
        );
        if (result) {
          return Right(addressEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update address'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
