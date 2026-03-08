import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/auth/data/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class GetCurrentUsecaseParams extends Equatable {
  final String userId;

  const GetCurrentUsecaseParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getCurrentUsecaseProvider = Provider<GetCurrentUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUsecase(authRepository: authRepository);
});

class GetCurrentUsecase
    implements UsecaseWithParms<UserEntity, GetCurrentUsecaseParams> {
  final IAuthRepository _authRepository;

  GetCurrentUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(GetCurrentUsecaseParams params) {
    return _authRepository.getCurrentUser(params.userId);
  }
}
