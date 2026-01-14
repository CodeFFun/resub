import 'package:resub/features/user/domain/entities/user_entity.dart';

class UserApiModel {
  final String? userId;
  final String email;
  final String? password;
  final String username;
  final String? fullName;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? alternateEmail;
  final Gender? gender;
  final Role role;

  UserApiModel({
    this.userId,
    required this.email,
    required this.username,
    this.password,
    this.fullName,
    this.profilePictureUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.alternateEmail,
    this.gender,
    this.role = Role.customer,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      alternateEmail: json['alternateEmail'] as String?,
      userId: json['_id'] as String?,
      gender: json['gender'] != null
          ? Gender.values.byName(json['gender'])
          : null,
      role: json['role'] != null
          ? Role.values.byName(json['role'])
          : Role.customer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'email': email,
      'password': password,
      'username': username,
      'fullName': fullName,
      'profilePictureUrl': profilePictureUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'alternateEmail': alternateEmail,
      'gender': gender?.name,
      'role': role.name,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      userName: username,
      fullName: fullName,
      profilePictureUrl: profilePictureUrl,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth != null ? DateTime.parse(dateOfBirth!) : null,
      alternateEmail: alternateEmail,
      gender: gender?.name,
      role: role.name,
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
      dateOfBirth: entity.dateOfBirth?.toIso8601String(),
      alternateEmail: entity.alternateEmail,
      gender: entity.gender != null
          ? Gender.values.byName(entity.gender!)
          : null,
      role: entity.role != null
          ? Role.values.byName(entity.role!)
          : Role.customer,
    );
  }

  static List<UserEntity> toEntityList(List<UserApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

enum Gender { male, female, other }

enum Role { customer, shop }
