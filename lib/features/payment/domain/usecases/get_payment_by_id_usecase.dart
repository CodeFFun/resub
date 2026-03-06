import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/payment/data/repositories/payment_repository.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';

class GetPaymentByIdUsecaseParams extends Equatable {
  final String paymentId;

  const GetPaymentByIdUsecaseParams({required this.paymentId});

  @override
  List<Object?> get props => [paymentId];
}

final getPaymentByIdUsecaseProvider = Provider<GetPaymentByIdUsecase>((ref) {
  final paymentRepository = ref.read(paymentRepositoryProvider);
  return GetPaymentByIdUsecase(paymentRepository: paymentRepository);
});

class GetPaymentByIdUsecase
    implements UsecaseWithParms<PaymentEntity?, GetPaymentByIdUsecaseParams> {
  final IPaymentRepository _paymentRepository;

  GetPaymentByIdUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, PaymentEntity?>> call(
    GetPaymentByIdUsecaseParams params,
  ) {
    return _paymentRepository.getPaymentById(params.paymentId);
  }
}
