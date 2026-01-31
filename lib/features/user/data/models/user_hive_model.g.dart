// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveModel(
      userId: fields[0] as String?,
      fullName: fields[1] as String?,
      email: fields[2] as String,
      userName: fields[3] as String,
      role: fields[5] as String?,
      profilePictureUrl: fields[6] as String?,
      phoneNumber: fields[7] as String?,

      alternateEmail: fields[9] as String?,
      gender: fields[10] as String?,
      password: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.profilePictureUrl)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.alternateEmail)
      ..writeByte(10)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
