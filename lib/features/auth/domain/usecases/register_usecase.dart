import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/auth/data/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class RegisterUsecaseParams extends Equatable {
  final String email;
  final String userName;
  final String password;

  const RegisterUsecaseParams({
    required this.email,
    required this.userName,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        userName,
        password,
      ];
}

//register provider

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool, RegisterUsecaseParams>{

  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final userEntity =  UserEntity(
      email: params.email,
      userName: params.userName,
      password: params.password,
    );
    return _authRepository.register(userEntity);
  }
}
