import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? id;
  final String? label;
  final String? line1;
  final String? city;
  final String? state;
  final String? country;

  const AddressEntity({
    this.id,
    this.label,
    this.line1,
    this.city,
    this.state,
    this.country,
  });

  AddressEntity copyWith({
    String? id,
    String? label,
    String? line1,
    String? city,
    String? state,
    String? country,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      line1: line1 ?? this.line1,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [id, label, line1, city, state, country];
}
