import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/order/presentation/pages/order_page_screen.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('order page screen renders empty state and handles tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    final overrides = await buildBaseOverrides(role: 'customer');
    overrides.add(
      paymentViewModelProvider.overrideWith(
        () => FakePaymentViewModel(
          const PaymentState(status: PaymentStatus.initial),
        ),
      ),
    );

    await tester.pumpWidget(
      wrapWithApp(OrderPageScreen(order: const []), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.text('Order Details'));
    await tester.pump();

    expect(find.text('No items in order'), findsOneWidget);
  });
}
