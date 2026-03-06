import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/payment/data/repositories/payment_repository.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';

class UpdatePaymentUsecaseParams extends Equatable {
  final String paymentId;
  final PaymentEntity paymentEntity;

  const UpdatePaymentUsecaseParams({
    required this.paymentId,
    required this.paymentEntity,
  });

  @override
  List<Object?> get props => [paymentId, paymentEntity];
}

final updatePaymentUsecaseProvider = Provider<UpdatePaymentUsecase>((ref) {
  final paymentRepository = ref.read(paymentRepositoryProvider);
  return UpdatePaymentUsecase(paymentRepository: paymentRepository);
});

class UpdatePaymentUsecase
    implements UsecaseWithParms<PaymentEntity?, UpdatePaymentUsecaseParams> {
  final IPaymentRepository _paymentRepository;

  UpdatePaymentUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, PaymentEntity?>> call(
    UpdatePaymentUsecaseParams params,
  ) {
    return _paymentRepository.updatePayment(
      params.paymentId,
      params.paymentEntity,
    );
  }
}
