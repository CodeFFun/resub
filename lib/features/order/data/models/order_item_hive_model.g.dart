// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderItemHiveModelAdapter extends TypeAdapter<OrderItemHiveModel> {
  @override
  final int typeId = 2;

  @override
  OrderItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItemHiveModel(
      id: fields[0] as String?,
      productId: fields[1] as String?,
      productName: fields[2] as String?,
      productBasePrice: fields[3] as double?,
      productDiscount: fields[4] as int?,
      quantity: fields[5] as int?,
      unitPrice: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItemHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.productBasePrice)
      ..writeByte(4)
      ..write(obj.productDiscount)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.unitPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
