import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/auth/domain/usecases/login_usecase.dart';
import 'package:resub/features/auth/domain/usecases/register_usecase.dart';
import 'package:resub/features/auth/domain/usecases/update_user_by_email_usecase.dart';
import 'package:resub/features/auth/presentation/state/auth_state.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

//provider
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final UpdateUserByEmailUsecase _updateUserByEmailUsecase;

  @override
  build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _updateUserByEmailUsecase = ref.read(updateUserByEmailUsecaseProvider);
    return AuthState();
  }

  Future<void> register({
    required String email,
    required String userName,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecaseParams(
      email: email,
      userName: userName,
      password: password,
    );
    final result = await _registerUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        if (user != null) {
          state = state.copyWith(status: AuthStatus.registered);
        } else {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: "Registration failed",
          );
        }
      },
    );
  }

  //login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      },
    );
  }

  //update user by email
  Future<void> updateUserByEmail({
    required String email,
    required UserEntity updateData,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = UpdateUserByEmailUsecaseParams(
      email: email,
      updateData: updateData,
    );
    final result = await _updateUserByEmailUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        if (isUpdated) {
          state = state.copyWith(status: AuthStatus.authenticated);
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Update failed",
          );
        }
      },
    );
  }
}
