import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String userName;
  final String email;
  final String? fullName;
  final String? role;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String? password;
  final DateTime? dateOfBirth;
  final String? alternateEmail;
  final String? gender;

  const UserEntity({
    this.userId,
    this.fullName,
    required this.email,
    required this.userName,
    this.role,
    this.profilePictureUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.alternateEmail,
    this.gender,
    this.password,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    profilePictureUrl,
    role,
    phoneNumber,
    dateOfBirth,
    alternateEmail,
    gender,
    userName,
    password,
  ];
}
