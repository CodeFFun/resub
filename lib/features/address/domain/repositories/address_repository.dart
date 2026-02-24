import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';

abstract interface class IAddressRepository {
  Future<Either<Failure, AddressEntity>> getAddressById(String id);
  Future<Either<Failure, AddressEntity>> createAddress(
    AddressEntity addressEntity,
  );
  Future<Either<Failure, List<AddressEntity>>> getAllAddressesOfAUser();
  Future<Either<Failure, AddressEntity>> updateAddress(
    String id,
    AddressEntity addressEntity,
  );
  Future<Either<Failure, bool>> deleteAddress(String id);
}
