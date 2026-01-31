import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, bool>> updateProfile(UserEntity updatedData);
  Future<Either<Failure, UserEntity?>> getUserById(String userId);
}
