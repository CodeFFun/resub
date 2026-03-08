import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/payment/data/repositories/payment_repository.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';

class DeletePaymentUsecaseParams extends Equatable {
  final String paymentId;

  const DeletePaymentUsecaseParams({required this.paymentId});

  @override
  List<Object?> get props => [paymentId];
}

final deletePaymentUsecaseProvider = Provider<DeletePaymentUsecase>((ref) {
  final paymentRepository = ref.read(paymentRepositoryProvider);
  return DeletePaymentUsecase(paymentRepository: paymentRepository);
});

class DeletePaymentUsecase
    implements UsecaseWithParms<bool, DeletePaymentUsecaseParams> {
  final IPaymentRepository _paymentRepository;

  DeletePaymentUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, bool>> call(DeletePaymentUsecaseParams params) {
    return _paymentRepository.deletePayment(params.paymentId);
  }
}
