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
    try {
      final result = await _hiveService.createPayment(paymentModel);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> deletePayment(String id) async {
    try {
      final result = await _hiveService.deletePayment(id);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> deleteAllPayments() async {
    return await _hiveService.deleteAllPayments();
  }

  @override
  Future<List<PaymentHiveModel>> getAllPayments() async {
    try {
      final result = _hiveService.getAllPayments();
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<PaymentHiveModel?> getPaymentById(String id) async {
    try {
      final result = _hiveService.getPaymentById(id);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<PaymentHiveModel>> getPaymentsByShopId(String shopId) async {
    try {
      final result = _hiveService.getPaymentsByShopId(shopId);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<PaymentHiveModel>> getPaymentsByUserId(String userId) async {
    try {
      final result = _hiveService.getPaymentsByUserId(userId);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<PaymentHiveModel>> getPaymentsOfShop(String userId) async {
    try {
      final result = _hiveService.getPaymentsOfShop(userId);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> updatePayment(String id, PaymentHiveModel paymentModel) async {
    try {
      final result = await _hiveService.updatePayment(id, paymentModel);
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }
}
