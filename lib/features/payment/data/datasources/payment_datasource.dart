import 'package:resub/features/payment/data/models/payment_model.dart';
import 'package:resub/features/payment/data/models/payment_hive_model.dart';

// Remote Datasource Interface
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

// Local Datasource Interface
abstract interface class IPaymentLocalDatasource {
  Future<PaymentHiveModel> createPayment(PaymentHiveModel paymentModel);
  Future<PaymentHiveModel?> getPaymentById(String id);
  Future<List<PaymentHiveModel>> getAllPayments();
  Future<List<PaymentHiveModel>> getPaymentsByUserId(String userId);
  Future<List<PaymentHiveModel>> getPaymentsByShopId(String shopId);
  Future<List<PaymentHiveModel>> getPaymentsOfShop(String userId);
  Future<bool> updatePayment(String id, PaymentHiveModel paymentModel);
  Future<bool> deletePayment(String id);
  Future<void> deleteAllPayments();
}
