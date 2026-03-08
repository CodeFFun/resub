import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';
import 'package:resub/features/payment/domain/usecases/create_payment_usecase.dart';

class _FakePaymentRepository implements IPaymentRepository {
  PaymentEntity? capturedPayment;

  @override
  Future<Either<Failure, PaymentEntity>> createPayment(
    PaymentEntity paymentEntity,
  ) async {
    capturedPayment = paymentEntity;
    return Right(paymentEntity);
  }

  @override
  Future<Either<Failure, PaymentEntity?>> getPaymentById(String id) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId() async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsOfShop() async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PaymentEntity?>> updatePayment(
    String id,
    PaymentEntity paymentEntity,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> deletePayment(String id) async =>
      throw UnimplementedError();
}

void main() {
  test('calls repository createPayment with payment entity', () async {
    final repository = _FakePaymentRepository();
    final usecase = CreatePaymentUsecase(paymentRepository: repository);
    const payment = PaymentEntity(amount: 99.0, provider: 'esewa');

    final result = await usecase(
      const CreatePaymentUsecaseParams(paymentEntity: payment),
    );

    expect(repository.capturedPayment, payment);
    expect(result, const Right(payment));
  });
}
