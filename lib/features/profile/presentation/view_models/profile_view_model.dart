import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/profile/domain/usecases/get_user_by_id_usecase.dart';
import 'package:resub/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:resub/features/profile/presentation/state/profile_state.dart';

//provider
final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdateProfileUsecase _updateProfileUsecase;
  late final GetUserByIdUsecase _getUserByIdUsecase;

  @override
  build() {
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _getUserByIdUsecase = ref.read(getUserByIdUsecaseProvider);
    return ProfileState();
  }

  //update profile
  Future<void> updateProfile({
    String? fullName,
    String? role,
    String? phoneNumber,
    String? alternateEmail,
    File? profilePictureUrl,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading);
    final params = UpdateProfileUsecaseParams(
      fullName: fullName,
      role: role,
      phoneNumber: phoneNumber,
      alternateEmail: alternateEmail,
      profilePictureUrl: profilePictureUrl,
    );
    final result = await _updateProfileUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        if (isUpdated) {
          state = state.copyWith(status: ProfileStatus.updated);
        } else {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "Profile update failed",
          );
        }
      },
    );
  }

  //get profile by id
  Future<void> getProfileById({required String userId}) async {
    state = state.copyWith(status: ProfileStatus.loading);
    final params = GetUserByIdUsecaseParams(userId: userId);
    final result = await _getUserByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        if (user != null) {
          state = state.copyWith(status: ProfileStatus.loaded, user: user);
        } else {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "User not found",
          );
        }
      },
    );
  }
}
