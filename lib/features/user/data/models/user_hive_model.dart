import 'package:hive/hive.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String? fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String userName;

  @HiveField(4)
  final String? password;

  @HiveField(5)
  final String? role;

  @HiveField(6)
  final String? profilePictureUrl;

  @HiveField(7)
  final String? phoneNumber;

  @HiveField(8)
  final DateTime? dateOfBirth;

  @HiveField(9)
  final String? alternateEmail;

  @HiveField(10)
  final String? gender;

  UserHiveModel({
    String? userId,
    this.fullName,
    required this.email,
    required this.userName,
    String? role,
    this.profilePictureUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.alternateEmail,
    this.gender,
    this.password,
  }) : userId = userId ?? Uuid().v4(),
       role = role ?? 'customer';

  //from entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      userName: entity.userName,
      role: entity.role,
      profilePictureUrl: entity.profilePictureUrl,
      phoneNumber: entity.phoneNumber,
      dateOfBirth: entity.dateOfBirth,
      alternateEmail: entity.alternateEmail,
      gender: entity.gender,
      password: entity.password,
    );
  }

  //to entity

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      userName: userName,
      role: role,
      profilePictureUrl: profilePictureUrl,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      alternateEmail: alternateEmail,
      gender: gender,
      password: password,
    );
  }
}
