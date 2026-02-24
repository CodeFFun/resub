import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/profile/data/repositories/profile_repository.dart';
import 'package:resub/features/profile/domain/repositories/profile_repository.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class UpdateProfileUsecaseParams extends Equatable {
  final String? fullName;
  final String? role;
  final String? phoneNumber;
  final String? alternateEmail;
  final File? profilePictureUrl;

  const UpdateProfileUsecaseParams({
    this.alternateEmail,
    this.fullName,
    this.phoneNumber,
    this.profilePictureUrl,
    this.role,
  });

  @override
  List<Object?> get props => [
    alternateEmail,
    fullName,
    phoneNumber,
    profilePictureUrl,
    role,
  ];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(profileRepository: profileRepository);
});

class UpdateProfileUsecase
    implements UsecaseWithParms<bool, UpdateProfileUsecaseParams> {
  final IProfileRepository _profileRepository;

  UpdateProfileUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProfileUsecaseParams params) {
    final userEntity = UserEntity(
      fullName: params.fullName,
      alternateEmail: params.alternateEmail,
      phoneNumber: params.phoneNumber,
      profilePictureUrl: params.profilePictureUrl,
      role: params.role,
    );
    return _profileRepository.updateProfile(userEntity);
  }
}
