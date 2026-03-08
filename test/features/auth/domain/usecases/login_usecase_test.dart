import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/usecases/login_usecase.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class _FakeAuthRepository implements IAuthRepository {
  String? capturedEmail;
  String? capturedPassword;

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    capturedEmail = email;
    capturedPassword = password;
    return const Right(UserEntity(email: 'user@test.com'));
  }

  @override
  Future<Either<Failure, UserEntity?>> register(UserEntity authEntity) async =>
      throw UnimplementedError();

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
  test('calls repository login with params', () async {
    final repository = _FakeAuthRepository();
    final usecase = LoginUsecase(authRepository: repository);

    final params = const LoginUsecaseParams(
      email: 'hello@test.com',
      password: 'secret',
    );
    final result = await usecase(params);

    expect(repository.capturedEmail, 'hello@test.com');
    expect(repository.capturedPassword, 'secret');
    expect(result.isRight(), isTrue);
  });
}
