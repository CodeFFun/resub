// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_category_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopCategoryHiveModelAdapter extends TypeAdapter<ShopCategoryHiveModel> {
  @override
  final int typeId = 5;

  @override
  ShopCategoryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopCategoryHiveModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      shopId: fields[3] as String?,
      shopIds: (fields[4] as List?)?.cast<String>(),
      shopName: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopCategoryHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.shopId)
      ..writeByte(4)
      ..write(obj.shopIds)
      ..writeByte(5)
      ..write(obj.shopName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopCategoryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
