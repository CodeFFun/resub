import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/auth/data/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecaseParams extends Equatable {
  final String userId;

  const LogoutUsecaseParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LogoutUsecase(authRepository: authRepository);
});

class LogoutUsecase implements UsecaseWithParms<bool, LogoutUsecaseParams> {
  final IAuthRepository _authRepository;

  LogoutUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(LogoutUsecaseParams params) {
    return _authRepository.logout(params.userId);
  }
}
