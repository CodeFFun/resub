// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionHiveModelAdapter extends TypeAdapter<SubscriptionHiveModel> {
  @override
  final int typeId = 10;

  @override
  SubscriptionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionHiveModel(
      id: fields[0] as String?,
      status: fields[1] as String?,
      remainingCycle: fields[2] as int?,
      subscriptionPlanId: fields[3] as String?,
      startDate: fields[4] as DateTime?,
      shopId: fields[5] as String?,
      userId: fields[6] as String?,
      paymentId: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.remainingCycle)
      ..writeByte(3)
      ..write(obj.subscriptionPlanId)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.shopId)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.paymentId)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
