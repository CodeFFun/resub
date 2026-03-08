import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/address/data/repositories/address_repository.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/domain/repositories/address_repository.dart';
import 'package:resub/features/address/presentation/state/address_state.dart';
import 'package:resub/features/address/presentation/view_models/address_view_model.dart';

class _FakeAddressRepository implements IAddressRepository {
  @override
  Future<Either<Failure, AddressEntity>> getAddressById(String id) async {
    return const Right(AddressEntity(id: 'a1', city: 'Kathmandu'));
  }

  @override
  Future<Either<Failure, AddressEntity>> createAddress(
    AddressEntity addressEntity,
  ) async {
    return Right(addressEntity.copyWith(id: 'created-id'));
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAllAddressesOfAUser() async {
    return const Right([AddressEntity(id: 'a1')]);
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(
    String id,
    AddressEntity addressEntity,
  ) async {
    return Right(addressEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deleteAddress(String id) async {
    return const Right(true);
  }
}

void main() {
  late ProviderContainer container;
  late AddressViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        addressRepositoryProvider.overrideWithValue(_FakeAddressRepository()),
      ],
    );
    viewModel = container.read(addressViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getAddressById sets loaded state with address', () async {
      await viewModel.getAddressById(addressId: 'a1');

      final state = container.read(addressViewModelProvider);
      expect(state.status, AddressStatus.loaded);
      expect(state.address?.id, 'a1');
    });
  });

  group('other methods', () {
    test('createAddress sets created state', () async {
      await viewModel.createAddress(
        addressEntity: const AddressEntity(city: 'Pokhara'),
      );

      final state = container.read(addressViewModelProvider);
      expect(state.status, AddressStatus.created);
      expect(state.address?.id, 'created-id');
    });
  });
}
