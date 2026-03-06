import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/payment/data/repositories/payment_repository.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';

final getPaymentsOfShopUsecaseProvider = Provider<GetPaymentsOfShopUsecase>((
  ref,
) {
  final paymentRepository = ref.read(paymentRepositoryProvider);
  return GetPaymentsOfShopUsecase(paymentRepository: paymentRepository);
});

class GetPaymentsOfShopUsecase
    implements UsecaseWithoutParms<List<PaymentEntity>> {
  final IPaymentRepository _paymentRepository;

  GetPaymentsOfShopUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, List<PaymentEntity>>> call() {
    return _paymentRepository.getPaymentsOfShop();
  }
}
