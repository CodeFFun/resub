// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHiveModelAdapter extends TypeAdapter<OrderHiveModel> {
  @override
  final int typeId = 3;

  @override
  OrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHiveModel(
      id: fields[0] as String?,
      orderItemsIds: (fields[1] as List?)?.cast<String>(),
      shopId: fields[2] as String?,
      shopName: fields[3] as String?,
      deliveryType: fields[4] as String?,
      scheduleFor: fields[5] as DateTime?,
      subscriptionId: fields[6] as String?,
      userId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderItemsIds)
      ..writeByte(2)
      ..write(obj.shopId)
      ..writeByte(3)
      ..write(obj.shopName)
      ..writeByte(4)
      ..write(obj.deliveryType)
      ..writeByte(5)
      ..write(obj.scheduleFor)
      ..writeByte(6)
      ..write(obj.subscriptionId)
      ..writeByte(7)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
