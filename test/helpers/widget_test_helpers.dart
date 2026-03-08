import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: implementation_imports
import 'package:riverpod/src/framework.dart' show Override;
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/address/presentation/state/address_state.dart';
import 'package:resub/features/address/presentation/view_models/address_view_model.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';
import 'package:resub/features/graph/presentation/state/graph_state.dart';
import 'package:resub/features/graph/presentation/view_models/graph_view_model.dart';
import 'package:resub/features/order/presentation/state/order_state.dart';
import 'package:resub/features/order/presentation/view_models/order_view_model.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';
import 'package:resub/features/profile/presentation/state/profile_state.dart';
import 'package:resub/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';
import 'package:resub/features/subscription/presentation/state/subscription_state.dart';
import 'package:resub/features/subscription/presentation/view_models/subscription_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Override>> buildBaseOverrides({
  String role = 'seller',
  String? userId,
}) async {
  final values = <String, Object>{'user_role': role};
  if (userId != null) {
    values['user_id'] = userId;
  }
  SharedPreferences.setMockInitialValues(values);
  final prefs = await SharedPreferences.getInstance();
  return [sharedPreferencesProvider.overrideWithValue(prefs)];
}

Widget wrapWithApp(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: child),
  );
}

void setLargeTestScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
}

class FakeAddressViewModel extends AddressViewModel {
  FakeAddressViewModel(this.initial);
  final AddressState initial;

  @override
  AddressState build() => initial;

  @override
  Future<void> getAddressesOfUser() async {}

  @override
  Future<void> createAddress({required addressEntity}) async {}

  @override
  Future<void> updateAddress({
    required String addressId,
    required addressEntity,
  }) async {}

  @override
  Future<void> deleteAddress({required String addressId}) async {}
}

class FakeProfileViewModel extends ProfileViewModel {
  FakeProfileViewModel(this.initial);
  final ProfileState initial;

  @override
  ProfileState build() => initial;

  @override
  Future<void> getProfileById({required String userId}) async {}
}

class FakePaymentViewModel extends PaymentViewModel {
  FakePaymentViewModel(this.initial);
  final PaymentState initial;

  @override
  PaymentState build() => initial;

  @override
  Future<void> getPaymentsByUserId() async {}

  @override
  Future<void> getPaymentsOfShop() async {}

  @override
  Future<void> initiateEsewaPayment({
    required String productName,
    required String amount,
    List<String>? orderIds,
    bool isTestEnvironment = true,
  }) async {}
}

class FakeOrderViewModel extends OrderViewModel {
  FakeOrderViewModel(this.initial);
  final OrderState initial;

  @override
  OrderState build() => initial;

  @override
  Future<void> getOrdersByUserId() async {}
}

class FakeSubscriptionViewModel extends SubscriptionViewModel {
  FakeSubscriptionViewModel(this.initial);
  final SubscriptionState initial;

  @override
  SubscriptionState build() => initial;

  @override
  Future<void> getAllSubscriptionsOfAUser() async {}
}

class FakeGraphViewModel extends GraphViewModel {
  FakeGraphViewModel(this.initial);
  final GraphState initial;

  @override
  GraphState build() => initial;

  @override
  Future<void> getShopOverview() async {}
}

class FakeCategoryViewModel extends CategoryViewModel {
  FakeCategoryViewModel(this.initial);
  final CategoryState initial;

  @override
  CategoryState build() => initial;

  @override
  Future<void> getAllShopCategories() async {}
}

class FakeShopViewModel extends ShopViewModel {
  FakeShopViewModel(this.initial);
  final ShopState initial;

  @override
  ShopState build() => initial;

  @override
  Future<void> getAllShops() async {}
}
