import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/payment/esewa_payment_service.dart';
import 'package:resub/core/usecases/app_usecases.dart';

class EsewaPaymentUsecaseParams extends Equatable {
  final String productName;
  final String amount;
  final String? callbackUrl;
  final bool isTestEnvironment;
  final Function(EsewaPaymentSuccessResult) onSuccess;
  final Function(String) onFailure;
  final Function(String) onCancellation;

  const EsewaPaymentUsecaseParams({
    required this.productName,
    required this.amount,
    this.callbackUrl,
    this.isTestEnvironment = true,
    required this.onSuccess,
    required this.onFailure,
    required this.onCancellation,
  });

  @override
  List<Object?> get props => [
    productName,
    amount,
    callbackUrl,
    isTestEnvironment,
    onSuccess,
    onFailure,
    onCancellation,
  ];
}

final esewaPaymentUsecaseProvider = Provider<EsewaPaymentUsecase>((ref) {
  final service = ref.read(esewaPaymentServiceProvider);
  return EsewaPaymentUsecase(esewaPaymentService: service);
});

class EsewaPaymentUsecase
    implements UsecaseWithParms<void, EsewaPaymentUsecaseParams> {
  final EsewaPaymentService _esewaPaymentService;

  EsewaPaymentUsecase({required EsewaPaymentService esewaPaymentService})
    : _esewaPaymentService = esewaPaymentService;

  @override
  Future<Either<Failure, void>> call(EsewaPaymentUsecaseParams params) async {
    await _esewaPaymentService.initiatePayment(
      productName: params.productName,
      amount: params.amount,
      callbackUrl: params.callbackUrl,
      onSuccess: params.onSuccess,
      onFailure: params.onFailure,
      onCancellation: params.onCancellation,
      isTestEnvironment: params.isTestEnvironment,
    );

    return const Right(null);
  }
}
