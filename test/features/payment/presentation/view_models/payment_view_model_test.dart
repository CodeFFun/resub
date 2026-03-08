import 'package:dartz/dartz.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/payment/esewa_payment_service.dart';
import 'package:resub/features/payment/data/repositories/payment_repository.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';

class _FakePaymentRepository implements IPaymentRepository {
  @override
  Future<Either<Failure, PaymentEntity?>> getPaymentById(String id) async {
    return const Right(
      PaymentEntity(id: 'pay-1', amount: 100, provider: 'cash'),
    );
  }

  @override
  Future<Either<Failure, PaymentEntity>> createPayment(
    PaymentEntity paymentEntity,
  ) async {
    return Right(paymentEntity.copyWith(id: 'created-pay'));
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsOfShop() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, PaymentEntity?>> updatePayment(
    String id,
    PaymentEntity paymentEntity,
  ) async {
    return Right(paymentEntity.copyWith(id: id));
  }

  @override
  Future<Either<Failure, bool>> deletePayment(String id) async {
    return const Right(true);
  }
}

class _FakeEsewaPaymentService extends EsewaPaymentService {
  _FakeEsewaPaymentService();

  @override
  Future<void> initiatePayment({
    required String productName,
    required String amount,
    String? callbackUrl,
    required Function(EsewaPaymentSuccessResult) onSuccess,
    required Function(String) onFailure,
    required Function(String) onCancellation,
    bool isTestEnvironment = true,
  }) async {}
}

void main() {
  late ProviderContainer container;
  late PaymentViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        paymentRepositoryProvider.overrideWithValue(_FakePaymentRepository()),
        esewaPaymentServiceProvider.overrideWithValue(
          _FakeEsewaPaymentService(),
        ),
      ],
    );
    viewModel = container.read(paymentViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('get methods', () {
    test('getPaymentById sets loaded state with payment', () async {
      await viewModel.getPaymentById(paymentId: 'pay-1');

      final state = container.read(paymentViewModelProvider);
      expect(state.status, PaymentStatus.loaded);
      expect(state.payment?.id, 'pay-1');
    });
  });

  group('other methods', () {
    test('createPayment sets created state', () async {
      await viewModel.createPayment(
        paymentEntity: const PaymentEntity(amount: 150, provider: 'esewa'),
      );

      final state = container.read(paymentViewModelProvider);
      expect(state.status, PaymentStatus.created);
      expect(state.payment?.id, 'created-pay');
    });
  });
}
