import 'package:equatable/equatable.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, updated, error, loaded }

class ProfileState extends Equatable {
  final ProfileStatus? status;
  final UserEntity? user;
  final String? errorMessage;

  const ProfileState({this.status, this.user, this.errorMessage});

  //copywith
  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
