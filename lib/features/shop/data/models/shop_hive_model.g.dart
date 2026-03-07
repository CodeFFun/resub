// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopHiveModelAdapter extends TypeAdapter<ShopHiveModel> {
  @override
  final int typeId = 6;

  @override
  ShopHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopHiveModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      pickupInfo: fields[2] as String?,
      about: fields[3] as String?,
      acceptsSubscription: fields[4] as bool?,
      addressId: fields[5] as String?,
      shopBanner: fields[6] as String?,
      userId: fields[7] as String?,
      categoryId: fields[8] as String?,
      addressLabel: fields[9] as String?,
      addressLine1: fields[10] as String?,
      categoryName: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pickupInfo)
      ..writeByte(3)
      ..write(obj.about)
      ..writeByte(4)
      ..write(obj.acceptsSubscription)
      ..writeByte(5)
      ..write(obj.addressId)
      ..writeByte(6)
      ..write(obj.shopBanner)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.categoryId)
      ..writeByte(9)
      ..write(obj.addressLabel)
      ..writeByte(10)
      ..write(obj.addressLine1)
      ..writeByte(11)
      ..write(obj.categoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
