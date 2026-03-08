import 'package:dartz/dartz.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/services/payment/esewa_payment_service.dart';
import 'package:resub/features/payment/domain/usecases/esewa_payment_usecase.dart';

class _FakeEsewaPaymentService extends EsewaPaymentService {
  _FakeEsewaPaymentService();

  bool initiateCalled = false;
  String? productName;
  String? amount;

  @override
  Future<void> initiatePayment({
    required String productName,
    required String amount,
    String? callbackUrl,
    required Function(EsewaPaymentSuccessResult) onSuccess,
    required Function(String) onFailure,
    required Function(String) onCancellation,
    bool isTestEnvironment = true,
  }) async {
    initiateCalled = true;
    this.productName = productName;
    this.amount = amount;
  }
}

void main() {
  test('calls eSewa service initiatePayment and returns Right', () async {
    final service = _FakeEsewaPaymentService();
    final usecase = EsewaPaymentUsecase(esewaPaymentService: service);

    final result = await usecase(
      EsewaPaymentUsecaseParams(
        productName: 'Milk Pack',
        amount: '100',
        onSuccess: (_) {},
        onFailure: (_) {},
        onCancellation: (_) {},
      ),
    );

    expect(service.initiateCalled, isTrue);
    expect(service.productName, 'Milk Pack');
    expect(service.amount, '100');
    expect(result, const Right(null));
  });
}
