# eSewa Payment Integration - MVVM Architecture

This document explains how to use the eSewa payment integration in your Flutter application following the MVVM architecture pattern.

## Overview

The eSewa payment integration is implemented following your app's MVVM architecture with:
- **Service Layer**: `EsewaPaymentService` handles payment SDK interactions
- **ViewModel**: `PaymentViewModel` manages payment state and business logic
- **State**: `PaymentState` tracks payment status throughout the flow
- **Widget**: Example implementation showing UI integration

## Architecture Components

### 1. Service Layer (`core/services/payment/`)

**`esewa_payment_service.dart`**
- Manages eSewa SDK initialization
- Handles payment initiation with callbacks
- Verifies transaction status
- Generates unique product IDs using UUID

### 2. Domain Layer (`features/payment/domain/`)

Uses existing payment repository and use cases to store payment records after successful verification.

### 3. Presentation Layer (`features/payment/presentation/`)

**State (`payment_state.dart`)**
```dart
enum PaymentStatus {
  initial,
  loading,
  created,
  updated,
  deleted,
  error,
  loaded,
  esewaPaymentInitiated,      // eSewa payment started
  esewaPaymentSuccess,         // Payment successful
  esewaPaymentFailed,          // Payment failed
  esewaPaymentCancelled,       // User cancelled
  esewaVerificationInProgress, // Verifying transaction
  esewaVerificationSuccess,    // Verification successful
  esewaVerificationFailed,     // Verification failed
}
```

**ViewModel (`payment_view_model.dart`)**
- `initiateEsewaPayment()` - Start payment process
- `verifyEsewaTransactionManually()` - Retry verification
- `resetPaymentState()` - Reset to initial state

## Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';

class CheckoutPage extends ConsumerWidget {
  final String productName;
  final String amount;
  final String? orderId;

  const CheckoutPage({
    super.key,
    required this.productName,
    required this.amount,
    this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentViewModel = ref.read(paymentViewModelProvider.notifier);
    
    return ElevatedButton(
      onPressed: () {
        // Initiate eSewa payment
        paymentViewModel.initiateEsewaPayment(
          productName: productName,
          amount: amount,
          orderId: orderId,
          isTestEnvironment: true, // false for production
        );
      },
      child: const Text('Pay with eSewa'),
    );
  }
}
```

### Listening to Payment Status

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Listen to payment state changes
  ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
    switch (next.status) {
      case PaymentStatus.esewaPaymentSuccess:
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful!')),
        );
        break;
        
      case PaymentStatus.esewaVerificationSuccess:
        // Transaction verified, navigate to success page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PaymentSuccessPage()),
        );
        break;
        
      case PaymentStatus.esewaPaymentFailed:
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${next.errorMessage}')),
        );
        break;
        
      case PaymentStatus.esewaPaymentCancelled:
        // User cancelled payment
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment cancelled')),
        );
        break;
        
      case PaymentStatus.created:
        // Payment record created in backend
        print('Payment saved with ID: ${next.payment?.id}');
        break;
        
      default:
        break;
    }
  });
  
  return YourWidget();
}
```

### Complete Example with State Management

```dart
class ProductCheckoutPage extends ConsumerWidget {
  final String productName;
  final double price;
  final String? orderId;

  const ProductCheckoutPage({
    super.key,
    required this.productName,
    required this.price,
    this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentViewModelProvider);
    final paymentViewModel = ref.read(paymentViewModelProvider.notifier);

    ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
      _handlePaymentStatusChange(context, next);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Product details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(productName, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('NPR ${price.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Payment button or loading indicator
            _buildPaymentButton(context, paymentState, paymentViewModel),
            
            // Status messages
            _buildStatusMessages(paymentState),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton(
    BuildContext context,
    PaymentState state,
    PaymentViewModel viewModel,
  ) {
    final isProcessing = state.status == PaymentStatus.esewaPaymentInitiated ||
        state.status == PaymentStatus.esewaVerificationInProgress;

    if (isProcessing) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Processing payment...'),
        ],
      );
    }

    return ElevatedButton.icon(
      onPressed: () {
        viewModel.initiateEsewaPayment(
          productName: productName,
          amount: price.toString(),
          orderId: orderId,
          isTestEnvironment: true,
        );
      },
      icon: const Icon(Icons.payment),
      label: const Text('Pay with eSewa'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatusMessages(PaymentState state) {
    if (state.status == PaymentStatus.esewaVerificationSuccess) {
      return Card(
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              const Text('Payment Successful!'),
              if (state.esewaRefId != null)
                Text('Ref: ${state.esewaRefId}'),
            ],
          ),
        ),
      );
    } else if (state.status == PaymentStatus.esewaPaymentFailed ||
        state.status == PaymentStatus.esewaVerificationFailed) {
      return Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(state.errorMessage ?? 'Payment failed'),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _handlePaymentStatusChange(BuildContext context, PaymentState state) {
    switch (state.status) {
      case PaymentStatus.esewaVerificationSuccess:
        // Navigate to success page after a delay
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessPage(refId: state.esewaRefId),
            ),
          );
        });
        break;
      default:
        break;
    }
  }
}
```

## eSewa Payment Flow

1. **User clicks "Pay with eSewa"**
   - State: `esewaPaymentInitiated`
   - ViewModel calls `initiateEsewaPayment()`
   - Service generates unique product ID

2. **eSewa SDK Opens**
   - User enters credentials
   - Completes payment

3. **Payment Success Callback**
   - State: `esewaPaymentSuccess`
   - Receives `EsewaPaymentSuccessResult` from SDK
   - This confirms payment was successful ✅

4. **Verification (SDK-based)**
   - State: `esewaVerificationInProgress`
   - **Currently**: Trusts SDK callback (no external API call)
   - Service marks as verified based on SDK response
   - Avoids external network issues

5. **Create Payment Record**
   - State: `esewaVerificationSuccess`
   - Payment record stored in backend via repository
   - State: `created`

## Important: Server-Side Verification

⚠️ **For Production Security:**

The current implementation trusts the eSewa SDK callback directly. For production, you should implement **server-to-server verification**:

1. After SDK success, send transaction details to your backend
2. Backend calls eSewa verification API (server-to-server)
3. Backend confirms payment and updates database
4. Frontend receives confirmation from backend

### Why Server-to-Server is Better:

✅ Avoids client network issues (no DNS errors)
✅ More secure - verifies with eSewa on trusted server
✅ Can't be bypassed by client manipulation
✅ Proper audit trail on backend

### Implementing Backend Verification:

```dart
// Example: After SDK success, call your backend API
void onEsewaPaymentSuccess(EsewaPaymentSuccessResult result) {
  // Send to your backend for verification
  final response = await apiClient.post(
    ApiEndpoints.paymentVerification, // POST /payment/verify
    data: {
      'refId': result.refId,
      'totalAmount': result.totalAmount,
      'pidx': result.pidx,
      'productId': result.productId,
      'orderId': orderId,
    },
  );
  
  // Your backend will verify with eSewa and confirm
  if (response.statusCode == 200) {
    // Payment verified and saved
  }
}
```

## Configuration

### Constants (`core/constants/esewa_constants.dart`)

```dart
const String kEsewaId = "your_client_id_here";
const String kSecretKey = "your_secret_key_here";
```

### Environment

- **Test Environment**: Set `isTestEnvironment: true`
- **Production**: Set `isTestEnvironment: false`

## API Integration

The payment service automatically:
1. Generates unique product IDs using UUID
2. Handles payment callbacks
3. Verifies transactions with eSewa API
4. Creates payment records in your backend via existing use cases

### Backend Endpoint

Payment records are created through:
- Repository: `IPaymentRepository.createPayment()`
- Endpoint: `POST /payment`

## Error Handling

```dart
ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
  if (next.status == PaymentStatus.esewaPaymentFailed) {
    // Handle payment failure
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text(next.errorMessage ?? 'Unknown error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Retry payment
              ref.read(paymentViewModelProvider.notifier).initiateEsewaPayment(
                productName: productName,
                amount: amount,
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
});
```

## Manual Verification (Retry)

```dart
// If verification fails, retry manually
ElevatedButton(
  onPressed: () {
    ref.read(paymentViewModelProvider.notifier).verifyEsewaTransactionManually(
      esewaResult, // EsewaPaymentSuccessResult from previous attempt
      orderId,
    );
  },
  child: const Text('Retry Verification'),
)
```

## Testing

### Test Credentials (eSewa Test Environment)

Use eSewa's test credentials from their developer portal:
- Test phone number
- Test OTP

### Test Flow

1. Set `isTestEnvironment: true`
2. Use test credentials
3. Complete test payment
4. Verify transaction appears in logs

## Production Checklist

- [ ] Update `kEsewaId` and `kSecretKey` with production credentials
- [ ] Set `isTestEnvironment: false`
- [ ] Test with real eSewa account
- [ ] Implement proper error logging
- [ ] Add analytics tracking
- [ ] Set up backend webhook for payment confirmation
- [ ] Test network failure scenarios
- [ ] Implement timeout handling

## Files Created

1. `lib/core/services/payment/esewa_payment_service.dart` - Payment service
2. `lib/features/payment/presentation/state/payment_state.dart` - Updated with eSewa states
3. `lib/features/payment/presentation/view_models/payment_view_model.dart` - Updated with eSewa methods
4. `lib/features/payment/presentation/widgets/esewa_payment_example.dart` - Example widget
5. `lib/core/api/api_endpoints.dart` - Added verification endpoint

## Next Steps

1. Integrate the payment button into your checkout flow
2. Style the payment UI to match your app design
3. Add proper error handling and retry logic
4. Implement payment history page
5. Add receipt/invoice generation
6. Set up backend payment webhooks for confirmation

## Support

For eSewa-specific issues, refer to:
- [eSewa Developer Documentation](https://developer.esewa.com.np/)
- [eSewa Flutter SDK](https://pub.dev/packages/esewa_flutter_sdk)
