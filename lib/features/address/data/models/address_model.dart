import 'package:resub/features/address/domain/entities/address_entity.dart';

class AddressApiModel {
  final String? id;
  final String? label;
  final String? line1;
  final String? city;
  final String? state;
  final String? country;
  final double? lat;
  final double? lng;
  final bool? isDefault;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressApiModel({
    this.id,
    this.label,
    this.line1,
    this.city,
    this.state,
    this.country,
    this.lat,
    this.lng,
    this.isDefault,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressApiModel.fromJson(Map<String, dynamic> json) {
    return AddressApiModel(
      id: json['_id'] as String?,
      label: json['label'] as String?,
      line1: json['line1'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (label != null) json['label'] = label;
    if (line1 != null) json['line1'] = line1;
    if (city != null) json['city'] = city;
    if (state != null) json['state'] = state;
    if (country != null) json['country'] = country;
    if (lat != null) json['lat'] = lat;
    if (lng != null) json['lng'] = lng;
    if (isDefault != null) json['is_default'] = isDefault;
    if (userId != null) json['userId'] = userId;
    if (createdAt != null) json['createdAt'] = createdAt?.toIso8601String();
    if (updatedAt != null) json['updatedAt'] = updatedAt?.toIso8601String();
    return json;
  }

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

  factory AddressApiModel.fromEntity(AddressEntity entity) {
    return AddressApiModel(
      id: entity.id,
      label: entity.label,
      line1: entity.line1,
      city: entity.city,
      state: entity.state,
      country: entity.country,
    );
  }

  static List<AddressEntity> toEntityList(List<AddressApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
