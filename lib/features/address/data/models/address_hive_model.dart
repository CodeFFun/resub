import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';

part 'address_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.addressTypeId)
class AddressHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? label;

  @HiveField(2)
  final String? line1;

  @HiveField(3)
  final String? city;

  @HiveField(4)
  final String? state;

  @HiveField(5)
  final String? country;

  @HiveField(6)
  final String? userId;

  AddressHiveModel({
    this.id,
    this.label,
    this.line1,
    this.city,
    this.state,
    this.country,
    this.userId,
  });

  // From entity
  factory AddressHiveModel.fromEntity(AddressEntity entity, {String? userId}) {
    return AddressHiveModel(
      id: entity.id,
      label: entity.label,
      line1: entity.line1,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      userId: userId,
    );
  }

  // To entity
  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      label: label,
      line1: line1,
      city: city,
      state: state,
      country: country,
    );
  }
}
