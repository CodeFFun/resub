import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/auth/data/datasources/auth_datasource.dart';
import 'package:resub/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:resub/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/user/data/models/user_api_model.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

//provider

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDataSource = ref.read(authLocalDatasourceProvider);
  final authRemoteDataSource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authLocalDatasource: authDataSource,
    authRemoteDatasource: authRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authLocalDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _authDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;
  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String userId) async {
    try {
      final user = await _authDatasource.getCurrentUser(userId);
      if (user != null) {
        final userEntity = user.toEntity();
        return Future.value(Right(userEntity));
      }
      return Left(LocalDatabaseFailure(message: 'User not found'));
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: "Invalid credentials"));
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
        final model = await _authDatasource.login(email, password);
        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }
        return const Left(
          LocalDatabaseFailure(message: "Invalid email or password"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout(String userId) async {
    try {
      final result = await _authDatasource.logout(userId);
      if (result) {
        return Right(result);
      }
      return Left(LocalDatabaseFailure(message: 'Logout failed'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> register(UserEntity authEntity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = UserApiModel.fromEntity(authEntity);
        final user = await _authRemoteDatasource.register(apiModel);
        final userEntity = user.toEntity();
        return Right(userEntity);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final authModel = UserHiveModel(
          userName: authEntity.userName,
          email: authEntity.email,
          password: authEntity.password,
        );
        final user = await _authDatasource.register(authModel);
        final userEntity = user?.toEntity();
        return Right(userEntity);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserByEmail(
    String email,
    UserEntity updateData,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = UserApiModel.fromEntity(updateData);
        final result = await _authRemoteDatasource.updateUserByEmail(
          email,
          apiModel,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Update failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final apiModel = UserHiveModel(
          fullName: updateData.fullName,
          phoneNumber: updateData.phoneNumber,
          role: updateData.role,
          alternateEmail: updateData.alternateEmail,
        );
        final result = await _authDatasource.updateUserByEmail(email, apiModel);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
