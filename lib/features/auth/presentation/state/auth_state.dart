import 'package:equatable/equatable.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

enum AuthStatus { initial, authenticated, unauthenticated, registered,loading, error }

class AuthState extends Equatable {
  final AuthStatus? status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status,
    this.user,
    this.errorMessage,
  });

  //copywith
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
