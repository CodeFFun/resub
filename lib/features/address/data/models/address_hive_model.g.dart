// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressHiveModelAdapter extends TypeAdapter<AddressHiveModel> {
  @override
  final int typeId = 1;

  @override
  AddressHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressHiveModel(
      id: fields[0] as String?,
      label: fields[1] as String?,
      line1: fields[2] as String?,
      city: fields[3] as String?,
      state: fields[4] as String?,
      country: fields[5] as String?,
      userId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddressHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.line1)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
