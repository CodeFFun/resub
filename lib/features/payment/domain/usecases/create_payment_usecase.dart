import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/payment/data/repositories/payment_repository.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';

class CreatePaymentUsecaseParams extends Equatable {
  final PaymentEntity paymentEntity;

  const CreatePaymentUsecaseParams({required this.paymentEntity});

  @override
  List<Object?> get props => [paymentEntity];
}

final createPaymentUsecaseProvider = Provider<CreatePaymentUsecase>((ref) {
  final paymentRepository = ref.read(paymentRepositoryProvider);
  return CreatePaymentUsecase(paymentRepository: paymentRepository);
});

class CreatePaymentUsecase
    implements UsecaseWithParms<PaymentEntity, CreatePaymentUsecaseParams> {
  final IPaymentRepository _paymentRepository;

  CreatePaymentUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, PaymentEntity>> call(
    CreatePaymentUsecaseParams params,
  ) {
    return _paymentRepository.createPayment(params.paymentEntity);
  }
}
