# Payment Feature Structure

This document outlines the complete payment feature structure created following the Clean Architecture pattern used in the address feature.

## Directory Structure

```
lib/features/payment/
├── domain/
│   ├── entities/
│   │   └── payment_entity.dart
│   ├── repositories/
│   │   └── payment_repository.dart
│   └── usecases/
│       ├── create_payment_usecase.dart
│       ├── delete_payment_usecase.dart
│       ├── get_payment_by_id_usecase.dart
│       ├── get_payments_by_user_id_usecase.dart
│       ├── get_payments_of_shop_usecase.dart
│       └── update_payment_usecase.dart
├── data/
│   ├── datasources/
│   │   ├── payment_datasource.dart
│   │   └── remote/
│   │       └── payment_remote_datasource.dart
│   ├── models/
│   │   └── payment_model.dart
│   └── repositories/
│       └── payment_repository.dart
└── presentation/
    ├── pages/
    ├── providers/
    ├── state/
    ├── view_models/
    └── widgets/
```

## Entity (PaymentEntity)

**File:** `domain/entities/payment_entity.dart`

Fields:
- `id`: String (MongoDB ObjectId)
- `provider`: String (default: "esewa")
- `status`: String (default: "completed")
- `amount`: double (required, min: 0)
- `paidAt`: DateTime (default: now)
- `orderId`: String (references Order)
- `subscriptionId`: String (references Subscription)
- `userId`: String (references User)
- `shopId`: String (references Shop)
- `orderItemsId`: List<String> (references OrderItems)
- `createdAt`: DateTime
- `updatedAt`: DateTime

Includes `copyWith()` method for immutable updates.

## Repository Interface (IPaymentRepository)

**File:** `domain/repositories/payment_repository.dart`

Methods:
- `createPayment(paymentEntity: PaymentEntity): Future<Either<Failure, PaymentEntity>>`
- `getPaymentById(id: String): Future<Either<Failure, PaymentEntity?>>`
- `getPaymentsByUserId(userId: String): Future<Either<Failure, List<PaymentEntity>>>`
- `getPaymentsOfShop(shopId: String): Future<Either<Failure, List<PaymentEntity>>>`
- `updatePayment(id: String, paymentEntity: PaymentEntity): Future<Either<Failure, PaymentEntity?>>`
- `deletePayment(id: String): Future<Either<Failure, bool>>`

## API Model (PaymentApiModel)

**File:** `data/models/payment_model.dart`

Handles JSON serialization/deserialization with:
- `fromJson()`: Parses API responses
- `toJson()`: Converts to API request format
- `toEntity()`: Converts to domain entity
- `fromEntity()`: Converts from domain entity

## Data Sources

### Interface (IPaymentRemoteDatasource)

**File:** `data/datasources/payment_datasource.dart`

Defines abstract methods matching the repository interface.

### Implementation (PaymentRemoteDatasource)

**File:** `data/datasources/remote/payment_remote_datasource.dart`

Uses:
- `ApiClient` for HTTP requests
- `TokenService` for authorization (Bearer token)
- `ApiEndpoints.payment` constant

All methods include token authorization headers.

## Repository Implementation (PaymentRepository)

**File:** `data/repositories/payment_repository.dart`

Features:
- Network connectivity checking via `NetworkInfo`
- Error handling with `Either<Failure, T>` pattern
- Conversion between models and entities
- Graceful offline handling

Provides `paymentRepositoryProvider` for dependency injection.

## Use Cases

All use cases follow the pattern from address feature:

1. **CreatePaymentUsecase** - Create a new payment
2. **GetPaymentByIdUsecase** - Fetch single payment
3. **GetPaymentsByUserIdUsecase** - Fetch all user payments
4. **GetPaymentsOfShopUsecase** - Fetch shop payments
5. **UpdatePaymentUsecase** - Update payment details
6. **DeletePaymentUsecase** - Delete payment record

Each usecase:
- Has a corresponding `Params` class extending `Equatable`
- Implements `UsecaseWithParms<T, Params>`
- Provides a riverpod provider for dependency injection
- Delegates to repository methods

## API Integration

**File:** `lib/core/api/api_endpoints.dart`

Added constant:
```dart
static const String payment = '/payment';
```

## API Endpoints Summary

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/payment` | Create payment |
| GET | `/payment/{id}` | Get payment by ID |
| GET | `/payment/user/{userId}` | Get user payments |
| GET | `/payment/shop/{shopId}` | Get shop payments |
| PUT | `/payment/{id}` | Update payment |
| DELETE | `/payment/{id}` | Delete payment |

## Dependency Injection Setup

The feature uses Riverpod providers for automatic dependency injection:

```dart
// Repository
final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) { ... });

// Data source
final paymentRemoteDatasourceProvider = Provider<IPaymentRemoteDatasource>((ref) { ... });

// Use cases
final createPaymentUsecaseProvider = Provider<CreatePaymentUsecase>((ref) { ... });
// ... more use case providers
```

## Error Handling

Uses the existing `Failure` class hierarchy:
- `ApiFailure` - Network/API errors
- Network connectivity checks prevent unnecessary API calls

## Next Steps

To complete the implementation:

1. **Presentation Layer** - Add ViewModels, State management, Pages, and Widgets
2. **Testing** - Unit tests for entities, repositories, and use cases
3. **Integration Tests** - Test the complete flow
4. **Backend Schema** - Ensure MongoDB schema matches the model structure

## Related Entities

The payment feature references these other models:
- `UserModel` - The user making the payment
- `OrderModel` - The order being paid for
- `SubscriptionModel` - Optional subscription payment
- `ShopModel` - The shop receiving payment (with addressId reference)
- `OrderItemModel` - Items in the order being paid for
