import 'dart:io';

import 'package:resub/features/user/domain/entities/user_entity.dart';

class UserApiModel {
  final String? userId;
  final String? email;
  final String? password;
  final String? username;
  final String? fullName;
  final String? profilePicture;
  final File? profilePictureUrl;
  final String? phoneNumber;
  final String? alternateEmail;
  final String? role;

  UserApiModel({
    this.userId,
    this.email,
    this.username,
    this.password,
    this.fullName,
    this.profilePicture,
    this.profilePictureUrl,
    this.phoneNumber,
    this.alternateEmail,
    this.role,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String?,
      profilePicture: json['profilePictureUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      alternateEmail: json['alternateEmail'] as String?,
      userId: json['_id'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (userId != null) json['_id'] = userId;
    if (email != null) json['email'] = email;
    if (password != null) json['password'] = password;
    if (username != null) json['username'] = username;
    if (fullName != null) json['fullName'] = fullName;
    if (phoneNumber != null) json['phoneNumber'] = phoneNumber;
    if (alternateEmail != null) json['alternateEmail'] = alternateEmail;
    if (role != null) json['role'] = role;
    return json;
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      userName: username,
      fullName: fullName,
      profilePicture: profilePicture,
      phoneNumber: phoneNumber,
      alternateEmail: alternateEmail,
      role: role,
    );
  }

  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      email: entity.email,
      username: entity.userName,
      fullName: entity.fullName,
      password: entity.password,
      profilePictureUrl: entity.profilePictureUrl,
      phoneNumber: entity.phoneNumber,
      alternateEmail: entity.alternateEmail,
      role: entity.role,
    );
  }

  static List<UserEntity> toEntityList(List<UserApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
