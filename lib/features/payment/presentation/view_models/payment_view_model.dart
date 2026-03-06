import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/payment/esewa_payment_service.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/usecases/create_payment_usecase.dart';
import 'package:resub/features/payment/domain/usecases/delete_payment_usecase.dart';
import 'package:resub/features/payment/domain/usecases/get_payment_by_id_usecase.dart';
import 'package:resub/features/payment/domain/usecases/get_payments_by_user_id_usecase.dart';
import 'package:resub/features/payment/domain/usecases/get_payments_of_shop_usecase.dart';
import 'package:resub/features/payment/domain/usecases/update_payment_usecase.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';

final paymentViewModelProvider =
    NotifierProvider<PaymentViewModel, PaymentState>(() => PaymentViewModel());

class PaymentViewModel extends Notifier<PaymentState> {
  late final CreatePaymentUsecase _createPaymentUsecase;
  late final DeletePaymentUsecase _deletePaymentUsecase;
  late final GetPaymentByIdUsecase _getPaymentByIdUsecase;
  late final GetPaymentsByUserIdUsecase _getPaymentsByUserIdUsecase;
  late final GetPaymentsOfShopUsecase _getPaymentsOfShopUsecase;
  late final UpdatePaymentUsecase _updatePaymentUsecase;
  late final EsewaPaymentService _esewaPaymentService;

  @override
  PaymentState build() {
    _createPaymentUsecase = ref.read(createPaymentUsecaseProvider);
    _deletePaymentUsecase = ref.read(deletePaymentUsecaseProvider);
    _getPaymentByIdUsecase = ref.read(getPaymentByIdUsecaseProvider);
    _getPaymentsByUserIdUsecase = ref.read(getPaymentsByUserIdUsecaseProvider);
    _getPaymentsOfShopUsecase = ref.read(getPaymentsOfShopUsecaseProvider);
    _updatePaymentUsecase = ref.read(updatePaymentUsecaseProvider);
    _esewaPaymentService = ref.read(esewaPaymentServiceProvider);
    return const PaymentState();
  }

  Future<void> createPayment({required PaymentEntity paymentEntity}) async {
    state = state.copyWith(status: PaymentStatus.loading);
    final params = CreatePaymentUsecaseParams(paymentEntity: paymentEntity);
    final result = await _createPaymentUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.error,
          errorMessage: failure.message,
        );
      },
      (payment) {
        state = state.copyWith(status: PaymentStatus.created, payment: payment);
      },
    );
  }

  Future<void> getPaymentById({required String paymentId}) async {
    state = state.copyWith(status: PaymentStatus.loading);
    final params = GetPaymentByIdUsecaseParams(paymentId: paymentId);
    final result = await _getPaymentByIdUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.error,
          errorMessage: failure.message,
        );
      },
      (payment) {
        state = state.copyWith(status: PaymentStatus.loaded, payment: payment);
      },
    );
  }

  Future<void> getPaymentsByUserId() async {
    state = state.copyWith(status: PaymentStatus.loading);
    final result = await _getPaymentsByUserIdUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.error,
          errorMessage: failure.message,
        );
      },
      (payments) {
        state = state.copyWith(
          status: PaymentStatus.loaded,
          payments: payments,
        );
      },
    );
  }

  Future<void> getPaymentsOfShop() async {
    state = state.copyWith(status: PaymentStatus.loading);
    final result = await _getPaymentsOfShopUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.error,
          errorMessage: failure.message,
        );
      },
      (payments) {
        state = state.copyWith(
          status: PaymentStatus.loaded,
          payments: payments,
        );
      },
    );
  }

  Future<void> updatePayment({
    required String paymentId,
    required PaymentEntity paymentEntity,
  }) async {
    state = state.copyWith(status: PaymentStatus.loading);
    final params = UpdatePaymentUsecaseParams(
      paymentId: paymentId,
      paymentEntity: paymentEntity,
    );
    final result = await _updatePaymentUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.error,
          errorMessage: failure.message,
        );
      },
      (payment) {
        state = state.copyWith(status: PaymentStatus.updated, payment: payment);
      },
    );
  }

  Future<void> deletePayment({required String paymentId}) async {
    state = state.copyWith(status: PaymentStatus.loading);
    final params = DeletePaymentUsecaseParams(paymentId: paymentId);
    final result = await _deletePaymentUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          state = state.copyWith(status: PaymentStatus.deleted);
        } else {
          state = state.copyWith(
            status: PaymentStatus.error,
            errorMessage: 'Payment deletion failed',
          );
        }
      },
    );
  }

  // ============ eSewa Payment Methods ============

  /// Initiate eSewa payment
  /// [productName] - Name of the product
  /// [amount] - Payment amount
  /// [orderIds] - Optional list of order IDs to link with payment
  /// [isTestEnvironment] - Use test environment (default: true)
  Future<void> initiateEsewaPayment({
    required String productName,
    required String amount,
    List<String>? orderIds,
    bool isTestEnvironment = true,
  }) async {
    state = state.copyWith(status: PaymentStatus.esewaPaymentInitiated);

    await _esewaPaymentService.initiatePayment(
      productName: productName,
      amount: amount,
      isTestEnvironment: isTestEnvironment,
      onSuccess: (result) async {
        state = state.copyWith(
          status: PaymentStatus.esewaPaymentSuccess,
          esewaRefId: result.refId,
        );
        // Automatically verify transaction
        await _verifyEsewaTransaction(result, orderIds);
      },
      onFailure: (error) {
        state = state.copyWith(
          status: PaymentStatus.esewaPaymentFailed,
          errorMessage: error,
        );
      },
      onCancellation: (message) {
        state = state.copyWith(
          status: PaymentStatus.esewaPaymentCancelled,
          errorMessage: message,
        );
      },
    );
  }

  /// Verify eSewa transaction and create payment record
  Future<void> _verifyEsewaTransaction(
    EsewaPaymentSuccessResult result,
    List<String>? orderIds,
  ) async {
    state = state.copyWith(status: PaymentStatus.esewaVerificationInProgress);

    final verificationResult = await _esewaPaymentService.verifyTransaction(
      result,
    );

    if (verificationResult.isSuccess) {
      state = state.copyWith(
        status: PaymentStatus.esewaVerificationSuccess,
        esewaTransactionStatus: verificationResult.status,
        esewaRefId: verificationResult.refId,
      );

      // Create payment record in backend
      await _createPaymentFromEsewaResult(result, orderIds);
    } else {
      state = state.copyWith(
        status: PaymentStatus.esewaVerificationFailed,
        errorMessage: verificationResult.message,
        esewaTransactionStatus: verificationResult.status,
      );
    }
  }

  /// Create payment record from eSewa result
  Future<void> _createPaymentFromEsewaResult(
    EsewaPaymentSuccessResult result,
    List<String>? orderIds,
  ) async {
    final paymentEntity = PaymentEntity(
      provider: 'esewa',
      status: 'completed',
      amount: double.parse(result.totalAmount),
      paidAt: DateTime.now(),
      orderId: orderIds,
    );

    await createPayment(paymentEntity: paymentEntity);
  }

  /// Manually trigger eSewa transaction verification
  /// Useful for retry scenarios
  Future<void> verifyEsewaTransactionManually(
    EsewaPaymentSuccessResult result,
    List<String>? orderIds,
  ) async {
    await _verifyEsewaTransaction(result, orderIds);
  }

  /// Reset payment state to initial
  void resetPaymentState() {
    state = const PaymentState(status: PaymentStatus.initial);
  }
}
