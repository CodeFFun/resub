import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class _FakeAuthRepository implements IAuthRepository {
  String? capturedUserId;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String userId) async {
    capturedUserId = userId;
    return const Right(UserEntity(userId: 'user-1', email: 'u@test.com'));
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
  Future<Either<Failure, bool>> logout(String userId) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> updateUserByEmail(
    String email,
    UserEntity updateData,
  ) async => throw UnimplementedError();
}

void main() {
  test('calls repository getCurrentUser with user id', () async {
    final repository = _FakeAuthRepository();
    final usecase = GetCurrentUsecase(authRepository: repository);

    const params = GetCurrentUsecaseParams(userId: 'user-1');
    final result = await usecase(params);

    expect(repository.capturedUserId, 'user-1');
    expect(result.isRight(), isTrue);
  });
}
