import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/dashboard/presentation/pages/bottom_navigation_screen/bottom_my_cart_screen.dart';
import 'package:resub/features/order/presentation/state/order_state.dart';
import 'package:resub/features/order/presentation/view_models/order_view_model.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';

import '../../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('bottom my cart screen renders seller payment view and taps', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    final overrides = await buildBaseOverrides(role: 'seller');
    overrides.addAll([
      orderViewModelProvider.overrideWith(
        () => FakeOrderViewModel(const OrderState(status: OrderStatus.initial)),
      ),
      paymentViewModelProvider.overrideWith(
        () => FakePaymentViewModel(
          const PaymentState(status: PaymentStatus.loaded, payments: []),
        ),
      ),
    ]);

    await tester.pumpWidget(
      wrapWithApp(const BottomMyCartScreen(), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.text('Order Payments'));
    await tester.pump();

    expect(find.text('No order payment history found'), findsOneWidget);
  });
}
