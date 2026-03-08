import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';

abstract interface class IPaymentRepository {
  Future<Either<Failure, PaymentEntity>> createPayment(
    PaymentEntity paymentEntity,
  );
  Future<Either<Failure, PaymentEntity?>> getPaymentById(String id);
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId();
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsOfShop();
  Future<Either<Failure, PaymentEntity?>> updatePayment(
    String id,
    PaymentEntity paymentEntity,
  );
  Future<Either<Failure, bool>> deletePayment(String id);
}
