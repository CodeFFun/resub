import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/usecases/logout_usecase.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class _FakeAuthRepository implements IAuthRepository {
  String? capturedUserId;

  @override
  Future<Either<Failure, bool>> logout(String userId) async {
    capturedUserId = userId;
    return const Right(true);
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity?>> register(UserEntity authEntity) async =>
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
  test('calls repository logout with user id', () async {
    final repository = _FakeAuthRepository();
    final usecase = LogoutUsecase(authRepository: repository);

    const params = LogoutUsecaseParams(userId: 'user-1');
    final result = await usecase(params);

    expect(repository.capturedUserId, 'user-1');
    expect(result, const Right(true));
  });
}
