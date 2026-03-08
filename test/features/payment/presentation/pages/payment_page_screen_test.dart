import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/payment/presentation/pages/payment_page_screen.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('payment page screen renders and supports tap and pump', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    final overrides = await buildBaseOverrides(role: 'customer');
    overrides.add(
      paymentViewModelProvider.overrideWith(
        () => FakePaymentViewModel(
          const PaymentState(status: PaymentStatus.loaded, payments: []),
        ),
      ),
    );

    await tester.pumpWidget(
      wrapWithApp(const PaymentPageScreen(), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.text('Payments'));
    await tester.pump();

    expect(find.text('No payment history found'), findsOneWidget);
  });
}
