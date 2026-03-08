import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/usecases/register_usecase.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class _FakeAuthRepository implements IAuthRepository {
  UserEntity? capturedUser;

  @override
  Future<Either<Failure, UserEntity?>> register(UserEntity authEntity) async {
    capturedUser = authEntity;
    return Right(authEntity);
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> logout(String userId) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String userId) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> updateUserByEmail(
    String email,
    UserEntity updateData,
  ) async => throw UnimplementedError();
}

void main() {
  test('builds UserEntity from params and calls repository', () async {
    final repository = _FakeAuthRepository();
    final usecase = RegisterUsecase(authRepository: repository);

    const params = RegisterUsecaseParams(
      email: 'hello@test.com',
      userName: 'hello',
      password: 'pw',
    );

    final result = await usecase(params);

    expect(repository.capturedUser?.email, 'hello@test.com');
    expect(repository.capturedUser?.userName, 'hello');
    expect(repository.capturedUser?.password, 'pw');
    expect(result.isRight(), isTrue);
  });
}
