import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';
import 'package:resub/features/payment/presentation/widgets/payment_invoice_bottom_sheet.dart';
import 'package:resub/features/payment/presentation/widgets/payment_list_tile.dart';

class OrderPaymentScreen extends ConsumerStatefulWidget {
  const OrderPaymentScreen({super.key});

  @override
  ConsumerState<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends ConsumerState<OrderPaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentViewModelProvider.notifier).getPaymentsOfShop();
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

  List<PaymentEntity> _filterOrderPayments(List<PaymentEntity> payments) {
    return payments.where((payment) {
      // Filter to only include payments where at least one order has orderItemsId
      if (payment.orders == null || payment.orders!.isEmpty) {
        return false;
      }
      return payment.orders!.any(
        (order) => order.orderItemsId != null && order.orderItemsId!.isNotEmpty,
      );
    }).toList();
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

    final allPayments = paymentState.payments ?? [];
    final filteredPayments = _filterOrderPayments(allPayments);
    final payments = _sortPayments(filteredPayments);
    final isLoading =
        paymentState.status == PaymentStatus.loading && payments.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Payments')),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(paymentViewModelProvider.notifier).getPaymentsOfShop();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : payments.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 220),
                  Center(
                    child: Text(
                      'No order payment history found',
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
