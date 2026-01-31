import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:resub/features/profile/data/datasources/profile_datasource.dart';
import 'package:resub/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:resub/features/profile/domain/repositories/profile_repository.dart';
import 'package:resub/features/user/data/models/user_api_model.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final profileLocalDatasource = ref.read(profileLocalDatasourceProvider);
  final profileRemoteDatasource = ref.read(profileRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ProfileRepository(
    profileLocalDatasource: profileLocalDatasource,
    profileRemoteDatasource: profileRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ProfileRepository implements IProfileRepository {
  final IProfileLocalDatasource _profileLocalDatasource;
  final IProfileRemoteDatasource _profileRemoteDatasource;
  final NetworkInfo _networkInfo;

  ProfileRepository({
    required IProfileLocalDatasource profileLocalDatasource,
    required IProfileRemoteDatasource profileRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _profileRemoteDatasource = profileRemoteDatasource,
       _networkInfo = networkInfo,
       _profileLocalDatasource = profileLocalDatasource;

  @override
  Future<Either<Failure, bool>> updateProfile(UserEntity updatedData) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = UserApiModel.fromEntity(updatedData);
        final model = await _profileRemoteDatasource.updatePersonalInfo(
          apiModel,
        );
        if (model != null) {
          return Right(true);
        }
        return const Left(ApiFailure(message: "Not updated"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Login failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        if (updatedData.profilePictureUrl != null) {
          return Left(
            LocalDatabaseFailure(
              message: "Profile picture update is not supported offline",
            ),
          );
        }
        final authModel = UserHiveModel(
          fullName: updatedData.fullName,
          phoneNumber: updatedData.phoneNumber,
          role: updatedData.role,
          alternateEmail: updatedData.alternateEmail,
        );
        await _profileLocalDatasource.updatePersonalInfo(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getUserById(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final userApiModel = await _profileRemoteDatasource.getUserById(userId);
        if (userApiModel != null) {
          final userEntity = userApiModel.toEntity();
          return Right(userEntity);
        } else {
          return const Left(ApiFailure(message: "User not found"));
        }
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final userHiveModel = await _profileLocalDatasource.getUserById(userId);
        if (userHiveModel != null) {
          final userEntity = userHiveModel.toEntity();
          return Right(userEntity);
        } else {
          return const Left(LocalDatabaseFailure(message: "User not found"));
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
