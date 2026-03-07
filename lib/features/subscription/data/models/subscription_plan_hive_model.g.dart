// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionPlanHiveModelAdapter
    extends TypeAdapter<SubscriptionPlanHiveModel> {
  @override
  final int typeId = 7;

  @override
  SubscriptionPlanHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionPlanHiveModel(
      id: fields[0] as String?,
      productIds: (fields[1] as List?)?.cast<String>(),
      productNames: (fields[2] as List?)?.cast<String>(),
      productQuantities: (fields[3] as List?)?.cast<int>(),
      productBasePrices: (fields[4] as List?)?.cast<num>(),
      productDiscounts: (fields[5] as List?)?.cast<int>(),
      pricePerCycle: fields[6] as num?,
      frequency: fields[7] as int?,
      quantity: fields[8] as int?,
      active: fields[9] as bool?,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionPlanHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productIds)
      ..writeByte(2)
      ..write(obj.productNames)
      ..writeByte(3)
      ..write(obj.productQuantities)
      ..writeByte(4)
      ..write(obj.productBasePrices)
      ..writeByte(5)
      ..write(obj.productDiscounts)
      ..writeByte(6)
      ..write(obj.pricePerCycle)
      ..writeByte(7)
      ..write(obj.frequency)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.active)
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
      other is SubscriptionPlanHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
