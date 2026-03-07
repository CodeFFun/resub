// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductHiveModelAdapter extends TypeAdapter<ProductHiveModel> {
  @override
  final int typeId = 9;

  @override
  ProductHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductHiveModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      basePrice: fields[3] as double,
      stockQuantity: fields[4] as int,
      discount: fields[5] as double,
      shopIds: (fields[6] as List).cast<String>(),
      categoryId: fields[7] as String,
      shopId: fields[8] as String?,
      categoryIds: (fields[9] as List?)?.cast<String>(),
      categoryNames: (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.basePrice)
      ..writeByte(4)
      ..write(obj.stockQuantity)
      ..writeByte(5)
      ..write(obj.discount)
      ..writeByte(6)
      ..write(obj.shopIds)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.shopId)
      ..writeByte(9)
      ..write(obj.categoryIds)
      ..writeByte(10)
      ..write(obj.categoryNames);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
