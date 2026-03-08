import 'package:equatable/equatable.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';

enum PaymentStatus {
  initial,
  loading,
  created,
  updated,
  deleted,
  error,
  loaded,
  esewaPaymentInitiated,
  esewaPaymentSuccess,
  esewaPaymentFailed,
  esewaPaymentCancelled,
  esewaVerificationInProgress,
  esewaVerificationSuccess,
  esewaVerificationFailed,
}

class PaymentState extends Equatable {
  final PaymentStatus? status;
  final PaymentEntity? payment;
  final List<PaymentEntity>? payments;
  final String? errorMessage;
  final String? esewaRefId;
  final String? esewaTransactionStatus;

  const PaymentState({
    this.status,
    this.payment,
    this.payments,
    this.errorMessage,
    this.esewaRefId,
    this.esewaTransactionStatus,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentEntity? payment,
    List<PaymentEntity>? payments,
    String? errorMessage,
    String? esewaRefId,
    String? esewaTransactionStatus,
  }) {
    return PaymentState(
      status: status ?? this.status,
      payment: payment ?? this.payment,
      payments: payments ?? this.payments,
      errorMessage: errorMessage ?? this.errorMessage,
      esewaRefId: esewaRefId ?? this.esewaRefId,
      esewaTransactionStatus:
          esewaTransactionStatus ?? this.esewaTransactionStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    payment,
    payments,
    errorMessage,
    esewaRefId,
    esewaTransactionStatus,
  ];
}
