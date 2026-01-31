import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/auth/data/repositories/auth_repository.dart';
import 'package:resub/features/auth/domain/repositories/auth_repository.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class UpdateUserByEmailUsecaseParams extends Equatable {
  final String email;
  final UserEntity updateData;

  const UpdateUserByEmailUsecaseParams({
    required this.email,
    required this.updateData,
  });

  @override
  List<Object?> get props => [email, updateData];
}

final updateUserByEmailUsecaseProvider = Provider<UpdateUserByEmailUsecase>((
  ref,
) {
  final authRepository = ref.read(authRepositoryProvider);
  return UpdateUserByEmailUsecase(authRepository: authRepository);
});

class UpdateUserByEmailUsecase
    implements UsecaseWithParms<bool, UpdateUserByEmailUsecaseParams> {
  final IAuthRepository _authRepository;

  UpdateUserByEmailUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateUserByEmailUsecaseParams params) {
    return _authRepository.updateUserByEmail(params.email, params.updateData);
  }
}
