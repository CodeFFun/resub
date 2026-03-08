// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductCategoryHiveModelAdapter
    extends TypeAdapter<ProductCategoryHiveModel> {
  @override
  final int typeId = 8;

  @override
  ProductCategoryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCategoryHiveModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      shopId: fields[3] as String?,
      shopIds: (fields[4] as List?)?.cast<String>(),
      shopName: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductCategoryHiveModel obj) {
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
      other is ProductCategoryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
