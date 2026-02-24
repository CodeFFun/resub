import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/profile/data/repositories/profile_repository.dart';
import 'package:resub/features/profile/domain/repositories/profile_repository.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class GetUserByIdUsecaseParams extends Equatable {
  final String userId;

  const GetUserByIdUsecaseParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getUserByIdUsecaseProvider = Provider<GetUserByIdUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return GetUserByIdUsecase(profileRepository: profileRepository);
});

class GetUserByIdUsecase
    implements UsecaseWithParms<UserEntity?, GetUserByIdUsecaseParams> {
  final IProfileRepository _profileRepository;

  GetUserByIdUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, UserEntity?>> call(GetUserByIdUsecaseParams params) {
    return _profileRepository.getUserById(params.userId);
  }
}
