import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/payment/data/datasources/payment_datasource.dart';
import 'package:resub/features/payment/data/models/payment_hive_model.dart';

final paymentLocalDatasourceProvider = Provider<IPaymentLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return PaymentLocalDatasource(hiveService: hiveService);
});

class PaymentLocalDatasource implements IPaymentLocalDatasource {
  final HiveService _hiveService;

  PaymentLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<PaymentHiveModel> createPayment(PaymentHiveModel paymentModel) async {
    return await _hiveService.createPayment(paymentModel);
  }

  @override
  Future<bool> deletePayment(String id) async {
    return await _hiveService.deletePayment(id);
  }

  @override
  Future<void> deleteAllPayments() async {
    return await _hiveService.deleteAllPayments();
  }

  @override
  Future<List<PaymentHiveModel>> getAllPayments() async {
    return _hiveService.getAllPayments();
  }

  @override
  Future<PaymentHiveModel?> getPaymentById(String id) async {
    return _hiveService.getPaymentById(id);
  }

  @override
  Future<List<PaymentHiveModel>> getPaymentsByShopId(String shopId) async {
    return _hiveService.getPaymentsByShopId(shopId);
  }

  @override
  Future<List<PaymentHiveModel>> getPaymentsByUserId(String userId) async {
    return _hiveService.getPaymentsByUserId(userId);
  }

  @override
  Future<bool> updatePayment(String id, PaymentHiveModel paymentModel) async {
    return await _hiveService.updatePayment(id, paymentModel);
  }
}
