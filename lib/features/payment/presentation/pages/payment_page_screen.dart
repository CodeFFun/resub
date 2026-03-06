import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';
import 'package:resub/features/payment/presentation/widgets/payment_invoice_bottom_sheet.dart';
import 'package:resub/features/payment/presentation/widgets/payment_list_tile.dart';

class PaymentPageScreen extends ConsumerStatefulWidget {
  const PaymentPageScreen({super.key});

  @override
  ConsumerState<PaymentPageScreen> createState() => _PaymentPageScreenState();
}

class _PaymentPageScreenState extends ConsumerState<PaymentPageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentViewModelProvider.notifier).getPaymentsByUserId();
    });
  }

  List<PaymentEntity> _sortPayments(List<PaymentEntity> payments) {
    final sortedPayments = [...payments];
    sortedPayments.sort((a, b) {
      final aDate =
          a.paidAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          b.paidAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return sortedPayments;
  }

  String _displayText(String? value, String fallback) {
    if (value == null || value.trim().isEmpty) {
      return fallback;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentViewModelProvider);

    ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
      if (next.status == PaymentStatus.error &&
          next.errorMessage != null &&
          next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    final payments = _sortPayments(paymentState.payments ?? []);
    final isLoading =
        paymentState.status == PaymentStatus.loading && payments.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(paymentViewModelProvider.notifier)
              .getPaymentsByUserId();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : payments.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 220),
                  Center(
                    child: Text(
                      'No payment history found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return PaymentListTile(
                    payment: payment,
                    userName: _displayText(
                      payment.userId?.userName ?? payment.userId?.userId,
                      'Unknown User',
                    ),
                    shopName: _displayText(
                      payment.shopId?.name ?? payment.shopId?.id,
                      'Unknown Shop',
                    ),
                    onEyePressed: () {
                      showPaymentInvoiceBottomSheet(
                        context: context,
                        payment: payment,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
