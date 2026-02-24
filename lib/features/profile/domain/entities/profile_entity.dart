import 'dart:io';

import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final DateTime? dateOfBirth;
  final File? profilePicture;
  final String? profilePictureUrl;

  const ProfileEntity({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.profilePicture,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [fullName, phoneNumber, email, dateOfBirth, profilePicture, profilePictureUrl];
}
