import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(UserEntity authEntity);
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, bool>> logout(String userId);
  Future<Either<Failure, UserEntity>> getCurrentUser(String userId);
}
