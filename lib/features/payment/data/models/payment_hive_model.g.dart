// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentHiveModelAdapter extends TypeAdapter<PaymentHiveModel> {
  @override
  final int typeId = 4;

  @override
  PaymentHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentHiveModel(
      id: fields[0] as String?,
      provider: fields[1] as String?,
      status: fields[2] as String?,
      amount: fields[3] as double,
      paidAt: fields[4] as DateTime?,
      orderId: (fields[5] as List?)?.cast<String>(),
      subscriptionId: fields[6] as String?,
      userId: fields[7] as String?,
      shopId: fields[8] as String?,
      orderItemsId: (fields[9] as List?)?.cast<String>(),
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.provider)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.paidAt)
      ..writeByte(5)
      ..write(obj.orderId)
      ..writeByte(6)
      ..write(obj.subscriptionId)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.shopId)
      ..writeByte(9)
      ..write(obj.orderItemsId)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
