import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/payment/presentation/pages/subscription_payment_screen.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/presentation/pages/subscription_page_screen.dart';
import 'package:resub/features/subscription/presentation/state/subscription_state.dart';
import 'package:resub/features/subscription/presentation/view_models/subscription_view_model.dart';

class BottomOrderScreen extends ConsumerStatefulWidget {
  const BottomOrderScreen({super.key});

  @override
  ConsumerState<BottomOrderScreen> createState() => _BottomOrderScreenState();
}

class _BottomOrderScreenState extends ConsumerState<BottomOrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShopData();
    });
  }

  Future<void> _loadShopData() async {
    ref
        .read(subscriptionViewModelProvider.notifier)
        .getAllSubscriptionsOfAUser();
  }

  @override
  Widget build(BuildContext context) {
    String checkRole() {
      final userSession = ref.read(userSessionServiceProvider);
      final role = userSession.getCurrentUSerRole();
      return role ?? '';
    }
    
    final subscriptionState = ref.watch(subscriptionViewModelProvider);
    ref.listen(subscriptionViewModelProvider, (previous, next) {
      if (next.status == SubscriptionStatus.updated ||
          next.status == SubscriptionStatus.deleted) {
        _loadShopData();
      }
    });
    if (subscriptionState.status == SubscriptionStatus.loading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Cart')),
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Colors.white,
      );
    }
    final subs =
        (subscriptionState.status == SubscriptionStatus.loaded ||
                subscriptionState.status == SubscriptionStatus.updated ||
                subscriptionState.status == SubscriptionStatus.deleted) &&
            subscriptionState.subscriptions != null
        ? subscriptionState.subscriptions!
        : <SubscriptionEntity>[];
    return checkRole() == 'customer' ? SubscriptionPageScreen(subscriptions: subs): SubscriptionPaymentScreen();
  }
}
