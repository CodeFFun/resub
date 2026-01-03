import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/auth/data/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;
  const LoginUsecaseParams({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

//provider for login usecase
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase implements UsecaseWithParms<UserEntity, LoginUsecaseParams> {
  final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUsecaseParams params) {
    return _authRepository.login(params.email, params.password);
  }
}
