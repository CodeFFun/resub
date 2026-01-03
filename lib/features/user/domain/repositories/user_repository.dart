import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, bool>> updateUser(UserEntity userEntity);
  Future<Either<Failure, UserEntity>> getUserById(String userId);
  Future<Either<Failure, UserEntity>> getUserByEmail(String email);
  Future<Either<Failure, bool>> deleteUser(String userId);
}