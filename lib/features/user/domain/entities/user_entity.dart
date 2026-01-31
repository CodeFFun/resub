import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String? userName;
  final String? email;
  final String? fullName;
  final String? role;
  final String? profilePicture;
  final File? profilePictureUrl;
  final String? phoneNumber;
  final String? password;
  final String? alternateEmail;
  final String? gender;

  const UserEntity({
    this.userId,
    this.fullName,
    this.email,
    this.userName,
    this.role,
    this.profilePicture,
    this.profilePictureUrl,
    this.phoneNumber,
    this.alternateEmail,
    this.gender,
    this.password,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    profilePicture,
    profilePictureUrl,
    role,
    phoneNumber,
    gender,
    userName,
    password,
  ];
}
