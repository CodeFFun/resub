import 'package:resub/features/payment/data/models/payment_model.dart';

abstract interface class IPaymentRemoteDatasource {
  Future<PaymentApiModel> createPayment(PaymentApiModel paymentModel);
  Future<PaymentApiModel?> getPaymentById(String id);
  Future<List<PaymentApiModel>> getPaymentsByUserId();
  Future<List<PaymentApiModel>> getPaymentsOfShop();
  Future<PaymentApiModel?> updatePayment(
    String id,
    PaymentApiModel paymentModel,
  );
  Future<bool> deletePayment(String id);
}
