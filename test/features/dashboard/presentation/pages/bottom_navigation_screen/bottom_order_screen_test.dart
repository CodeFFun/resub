import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/dashboard/presentation/pages/bottom_navigation_screen/bottom_order_screen.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';
import 'package:resub/features/subscription/presentation/state/subscription_state.dart';
import 'package:resub/features/subscription/presentation/view_models/subscription_view_model.dart';

import '../../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets(
    'bottom order screen renders seller subscription payments and taps',
    (tester) async {
      setLargeTestScreen(tester);

      final overrides = await buildBaseOverrides(role: 'seller');
      overrides.addAll([
        subscriptionViewModelProvider.overrideWith(
          () => FakeSubscriptionViewModel(
            const SubscriptionState(status: SubscriptionStatus.initial),
          ),
        ),
        paymentViewModelProvider.overrideWith(
          () => FakePaymentViewModel(
            const PaymentState(status: PaymentStatus.loaded, payments: []),
          ),
        ),
      ]);

      await tester.pumpWidget(
        wrapWithApp(const BottomOrderScreen(), overrides: overrides),
      );
      await tester.pump();

      await tester.tap(find.text('Subscription Payments'));
      await tester.pump();

      expect(
        find.text('No subscription payment history found'),
        findsOneWidget,
      );
    },
  );
}
