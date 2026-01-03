import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/auth/data/datasources/auth_datasource.dart';
import 'package:resub/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

//provider

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(authDatasource: ref.read(authLocalDatasourceProvider));
});

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDatasource;

  AuthRepository({required IAuthDatasource authDatasource})
    : _authDatasource = authDatasource;
  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String userId) async{
    try {
      final user = await _authDatasource.getCurrentUser(userId);
      if(user != null){
        final userEntity = user.toEntity();
        return Future.value(Right(userEntity));
      }
      return Left( LocalDatabaseFailure(message: 'User not found'));
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async{
    try {
      final user = await _authDatasource.login(email, password);
      if(user != null){
        final userEntity = user.toEntity();
        return Right(userEntity);
      }
      return Left(LocalDatabaseFailure(message: 'Login failed'));
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> logout(String userId) async{
    try {
      final result = await _authDatasource.logout(userId);
      if(result){
        return Right(result);
      }
      return Left(LocalDatabaseFailure(message: 'Logout failed'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(UserEntity authEntity) async{
    try {
      final model = UserHiveModel.fromEntity(authEntity);
      final result = await _authDatasource.register(model);
      if(result){
        return Right(result);
      }
      return Left(LocalDatabaseFailure(message: 'Registration failed'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
