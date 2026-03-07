import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/core/services/hive/hive_seeder.dart';
import 'package:resub/features/address/data/models/address_hive_model.dart';
import 'package:resub/features/category/data/models/product_category_hive_model.dart';
import 'package:resub/features/category/data/models/shop_category_hive_model.dart';
import 'package:resub/features/order/data/models/order_hive_model.dart';
import 'package:resub/features/order/data/models/order_item_hive_model.dart';
import 'package:resub/features/payment/data/models/payment_hive_model.dart';
import 'package:resub/features/product/data/models/product_hive_model.dart';
import 'package:resub/features/shop/data/models/shop_hive_model.dart';
import 'package:resub/features/subscription/data/models/subscription_hive_model.dart';
import 'package:resub/features/subscription/data/models/subscription_plan_hive_model.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    // register adapter
    _registerAdapter();
    await _openBoxes();
    await HiveSeeder.seedDatabase();
  }

  // Adapter register
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.addressTypeId)) {
      Hive.registerAdapter(AddressHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.orderItemsTypeId)) {
      Hive.registerAdapter(OrderItemHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.orderTypeId)) {
      Hive.registerAdapter(OrderHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.paymentsTypeId)) {
      Hive.registerAdapter(PaymentHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.shopCategoriesTypeId)) {
      Hive.registerAdapter(ShopCategoryHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.shopsTypeId)) {
      Hive.registerAdapter(ShopHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.subscriptionPlansTypeId)) {
      Hive.registerAdapter(SubscriptionPlanHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.productCategoriesTypeId)) {
      Hive.registerAdapter(ProductCategoryHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.productsTypeId)) {
      Hive.registerAdapter(ProductHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.subscriptionsTypeId)) {
      Hive.registerAdapter(SubscriptionHiveModelAdapter());
    }
  }

  // box open
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<AddressHiveModel>(HiveTableConstant.addressTable);
    await Hive.openBox<OrderItemHiveModel>(HiveTableConstant.orderItemsTable);
    await Hive.openBox<OrderHiveModel>(HiveTableConstant.orderTable);
    await Hive.openBox<PaymentHiveModel>(HiveTableConstant.paymentsTable);
    await Hive.openBox<ShopCategoryHiveModel>(
      HiveTableConstant.shopCategoriesTable,
    );
    await Hive.openBox<ShopHiveModel>(HiveTableConstant.shopsTable);
    await Hive.openBox<SubscriptionPlanHiveModel>(
      HiveTableConstant.subscriptionPlansTable,
    );
    await Hive.openBox<ProductCategoryHiveModel>(
      HiveTableConstant.productCategoriesTable,
    );
    await Hive.openBox<ProductHiveModel>(HiveTableConstant.productsTable);
    await Hive.openBox<SubscriptionHiveModel>(
      HiveTableConstant.subscriptionsTable,
    );
  }

  // box close
  Future<void> _close() async {
    await Hive.close();
  }

  // ======================= Auth Queries =========================

  Box<UserHiveModel> get _authBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  // Register user
  Future<UserHiveModel?> register(UserHiveModel user) async {
    print('Registering user:');
    print('  - userId: ${user.userId}');
    print('  - email: ${user.email}');
    print('  - password: ${user.password}');
    print('  - userName: ${user.userName}');
    print('  - fullName: ${user.fullName}');
    await _authBox.put(user.userId, user);

    // Verify the save
    final savedUser = _authBox.get(user.userId);
    print('Verified saved user:');
    print('  - email: ${savedUser?.email}');
    print('  - password: ${savedUser?.password}');

    return user;
  }

  // Delete user by userId (for cleanup)
  Future<void> deleteUser(String userId) async {
    await _authBox.delete(userId);
    print('Deleted user with userId: $userId');
  }

  // Delete all users (for cleanup/reset)
  Future<void> deleteAllUsers() async {
    await _authBox.clear();
    print('Deleted all users from database');
  }

  // Get user by email (for debugging)
  UserHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Login - find user by email and password
  UserHiveModel? login(String email, String password) {
    print(
      'HiveService login - Searching for email: "$email", password: "$password"',
    );
    print('Total users in box: ${_authBox.length}');

    // Debug: print all users and check for corrupted data
    for (var user in _authBox.values) {
      print(
        'User in DB - UserId: "${user.userId}", Email: "${user.email}", Password: "${user.password}", UserName: "${user.userName}"',
      );

      // Clean up corrupted users (null email or password)
      if (user.email == null || user.password == null) {
        print('WARNING: Found corrupted user with userId: ${user.userId}');
        print('  - This user has null email or password and should be deleted');
      }
    }

    final users = _authBox.values.where(
      (user) =>
          user.email != null &&
          user.password != null &&
          user.email == email &&
          user.password == password,
    );

    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }

  //get current user
  UserHiveModel? getCurrentUser(String userId) {
    return _authBox.get(userId);
  }

  //logout
  Future<bool> logout(String userId) async {
    await _authBox.delete(userId);
    return true;
  }

  // Get user by ID
  UserHiveModel? getUserById(String userId) {
    return _authBox.get(userId);
  }

  // Update user
  Future<bool> updateUser(UserHiveModel user) async {
    if (_authBox.containsKey(user.userId)) {
      await _authBox.put(user.userId, user);
      return true;
    }
    return false;
  }

  // Update user by email
  bool updateUserByEmail(String email, UserHiveModel updateData) {
    try {
      final user = getUserByEmail(email);
      if (user != null) {
        // Preserve all existing fields and only update provided ones
        final updatedUser = UserHiveModel(
          userId: user.userId,
          email: updateData.email ?? user.email,
          password: updateData.password ?? user.password,
          userName: updateData.userName ?? user.userName,
          fullName: updateData.fullName ?? user.fullName,
          role: updateData.role ?? user.role,
          phoneNumber: updateData.phoneNumber ?? user.phoneNumber,
          profilePictureUrl:
              updateData.profilePictureUrl ?? user.profilePictureUrl,
          alternateEmail: updateData.alternateEmail ?? user.alternateEmail,
          gender: updateData.gender ?? user.gender,
        );

        _authBox.put(updatedUser.userId, updatedUser);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ======================= Address Queries =========================

  Box<AddressHiveModel> get _addressBox =>
      Hive.box<AddressHiveModel>(HiveTableConstant.addressTable);

  Future<AddressHiveModel> createAddress(AddressHiveModel address) async {
    final key = address.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    final addressToSave = AddressHiveModel(
      id: key,
      label: address.label,
      line1: address.line1,
      city: address.city,
      state: address.state,
      country: address.country,
      userId: address.userId,
    );
    await _addressBox.put(key, addressToSave);
    return addressToSave;
  }

  AddressHiveModel? getAddressById(String id) {
    return _addressBox.get(id);
  }

  List<AddressHiveModel> getAllAddressOfAUser(String userId) {
    return _addressBox.values
        .where((address) => address.userId == userId)
        .toList();
  }

  Future<bool> updateAddress(String id, AddressHiveModel address) async {
    if (_addressBox.containsKey(id)) {
      await _addressBox.put(id, address);
      return true;
    }
    return false;
  }

  Future<bool> deleteAddress(String id) async {
    await _addressBox.delete(id);
    return true;
  }

  Future<void> deleteAllAddresses() async {
    await _addressBox.clear();
  }

  // ======================= Shop Category Queries =========================

  Box<ShopCategoryHiveModel> get _shopCategoryBox =>
      Hive.box<ShopCategoryHiveModel>(HiveTableConstant.shopCategoriesTable);

  Future<ShopCategoryHiveModel> createShopCategory(
    ShopCategoryHiveModel category,
  ) async {
    await _shopCategoryBox.put(category.id, category);
    return category;
  }

  ShopCategoryHiveModel? getShopCategoryById(String id) {
    return _shopCategoryBox.get(id);
  }

  List<ShopCategoryHiveModel> getAllShopCategories() {
    return _shopCategoryBox.values.toList();
  }

  Future<bool> updateShopCategory(
    String id,
    ShopCategoryHiveModel category,
  ) async {
    if (_shopCategoryBox.containsKey(id)) {
      await _shopCategoryBox.put(id, category);
      return true;
    }
    return false;
  }

  Future<bool> deleteShopCategory(String id) async {
    await _shopCategoryBox.delete(id);
    return true;
  }

  Future<void> deleteAllShopCategories() async {
    await _shopCategoryBox.clear();
  }

  // ======================= Product Category Queries =========================

  Box<ProductCategoryHiveModel> get _productCategoryBox =>
      Hive.box<ProductCategoryHiveModel>(
        HiveTableConstant.productCategoriesTable,
      );

  Future<ProductCategoryHiveModel> createProductCategory(
    ProductCategoryHiveModel category,
  ) async {
    final key = category.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    category = ProductCategoryHiveModel(
      id: key,
      name: category.name,
      description: category.description,
      shopId: category.shopId,
    );
    await _productCategoryBox.put(category.id, category);
    return category;
  }

  ProductCategoryHiveModel? getProductCategoryById(String id) {
    final category = _productCategoryBox.get(id);
    if (category != null && category.shopId != null) {
      final shop = getShopById(category.shopId!);
      if (shop != null) {
        return ProductCategoryHiveModel(
          id: category.id,
          name: category.name,
          description: category.description,
          shopId: category.shopId,
          shopIds: category.shopIds,
          shopName: shop.name,
        );
      }
    }
    return category;
  }

  List<ProductCategoryHiveModel> getAllProductCategories() {
    return _productCategoryBox.values.map((category) {
      if (category.shopId != null) {
        final shop = getShopById(category.shopId!);
        if (shop != null) {
          return ProductCategoryHiveModel(
            id: category.id,
            name: category.name,
            description: category.description,
            shopId: category.shopId,
            shopIds: category.shopIds,
            shopName: shop.name,
          );
        }
      }
      return category;
    }).toList();
  }

  List<ProductCategoryHiveModel> getProductCategoriesByShopId(String shopId) {
    final shop = getShopById(shopId);
    return _productCategoryBox.values
        .where(
          (category) =>
              category.shopId == shopId ||
              (category.shopIds?.contains(shopId) ?? false),
        )
        .map((category) {
          return ProductCategoryHiveModel(
            id: category.id,
            name: category.name,
            description: category.description,
            shopId: category.shopId,
            shopIds: category.shopIds,
            shopName: shop?.name ?? category.shopName,
          );
        })
        .toList();
  }

  Future<bool> updateProductCategory(
    String id,
    ProductCategoryHiveModel category,
  ) async {
    if (_productCategoryBox.containsKey(id)) {
      await _productCategoryBox.put(id, category);
      return true;
    }
    return false;
  }

  Future<bool> deleteProductCategory(String id) async {
    await _productCategoryBox.delete(id);
    return true;
  }

  Future<void> deleteAllProductCategories() async {
    await _productCategoryBox.clear();
  }

  // ======================= Order Queries =========================

  Box<OrderHiveModel> get _orderBox =>
      Hive.box<OrderHiveModel>(HiveTableConstant.orderTable);

  Future<OrderHiveModel> createOrder(OrderHiveModel order) async {
    await _orderBox.put(order.id, order);
    return order;
  }

  OrderHiveModel? getOrderById(String id) {
    final order = _orderBox.get(id);
    if (order != null) {
      return _populateOrderRelations(order);
    }
    return null;
  }

  List<OrderHiveModel> getAllOrders() {
    return _orderBox.values
        .map((order) => _populateOrderRelations(order))
        .toList();
  }

  List<OrderHiveModel> getOrdersByUserId(String userId) {
    return _orderBox.values
        .where((order) => order.userId == userId)
        .map((order) => _populateOrderRelations(order))
        .toList();
  }

  List<OrderHiveModel> getOrdersByShopId(String shopId) {
    return _orderBox.values
        .where((order) => order.shopId == shopId)
        .map((order) => _populateOrderRelations(order))
        .toList();
  }

  // Helper method to populate order relations
  OrderHiveModel _populateOrderRelations(OrderHiveModel order) {
    String? shopName = order.shopName;
    if (order.shopId != null && shopName == null) {
      final shop = getShopById(order.shopId!);
      shopName = shop?.name;
    }
    return OrderHiveModel(
      id: order.id,
      orderItemsIds: order.orderItemsIds,
      shopId: order.shopId,
      shopName: shopName,
      deliveryType: order.deliveryType,
      scheduleFor: order.scheduleFor,
      subscriptionId: order.subscriptionId,
      userId: order.userId,
    );
  }

  Future<bool> updateOrder(String id, OrderHiveModel order) async {
    if (_orderBox.containsKey(id)) {
      await _orderBox.put(id, order);
      return true;
    }
    return false;
  }

  Future<bool> deleteOrder(String id) async {
    await _orderBox.delete(id);
    return true;
  }

  Future<void> deleteAllOrders() async {
    await _orderBox.clear();
  }

  // ======================= Order Item Queries =========================

  Box<OrderItemHiveModel> get _orderItemBox =>
      Hive.box<OrderItemHiveModel>(HiveTableConstant.orderItemsTable);

  Future<OrderItemHiveModel> createOrderItem(
    OrderItemHiveModel orderItem,
  ) async {
    await _orderItemBox.put(orderItem.id, orderItem);
    return orderItem;
  }

  OrderItemHiveModel? getOrderItemById(String id) {
    return _orderItemBox.get(id);
  }

  List<OrderItemHiveModel> getAllOrderItems() {
    return _orderItemBox.values.toList();
  }

  List<OrderItemHiveModel> getOrderItemsByIds(List<String> ids) {
    return ids
        .map((id) => _orderItemBox.get(id))
        .whereType<OrderItemHiveModel>()
        .toList();
  }

  Future<bool> updateOrderItem(String id, OrderItemHiveModel orderItem) async {
    if (_orderItemBox.containsKey(id)) {
      await _orderItemBox.put(id, orderItem);
      return true;
    }
    return false;
  }

  Future<bool> deleteOrderItem(String id) async {
    await _orderItemBox.delete(id);
    return true;
  }

  Future<void> deleteAllOrderItems() async {
    await _orderItemBox.clear();
  }

  // ======================= Payment Queries =========================

  Box<PaymentHiveModel> get _paymentBox =>
      Hive.box<PaymentHiveModel>(HiveTableConstant.paymentsTable);

  Future<PaymentHiveModel> createPayment(PaymentHiveModel payment) async {
    await _paymentBox.put(payment.id, payment);
    return payment;
  }

  PaymentHiveModel? getPaymentById(String id) {
    return _paymentBox.get(id);
  }

  List<PaymentHiveModel> getAllPayments() {
    return _paymentBox.values.toList();
  }

  List<PaymentHiveModel> getPaymentsByUserId(String userId) {
    return _paymentBox.values
        .where((payment) => payment.userId == userId)
        .toList();
  }

  List<PaymentHiveModel> getPaymentsByShopId(String shopId) {
    return _paymentBox.values
        .where((payment) => payment.shopId == shopId)
        .toList();
  }

  Future<bool> updatePayment(String id, PaymentHiveModel payment) async {
    if (_paymentBox.containsKey(id)) {
      await _paymentBox.put(id, payment);
      return true;
    }
    return false;
  }

  Future<bool> deletePayment(String id) async {
    await _paymentBox.delete(id);
    return true;
  }

  Future<void> deleteAllPayments() async {
    await _paymentBox.clear();
  }

  // ======================= Product Queries =========================

  Box<ProductHiveModel> get _productBox =>
      Hive.box<ProductHiveModel>(HiveTableConstant.productsTable);

  Future<ProductHiveModel> createProduct(ProductHiveModel product) async {
    final key = product.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    product = ProductHiveModel(
      id: key,
      name: product.name,
      description: product.description,
      stockQuantity: product.stockQuantity,
      discount: product.discount,
      basePrice: product.basePrice,
      shopIds: product.shopIds,
      categoryId: product.categoryId,
    );
    await _productBox.put(product.id, product);
    return product;
  }

  ProductHiveModel? getProductById(String id) {
    return _productBox.get(id);
  }

  List<ProductHiveModel> getAllProducts() {
    return _productBox.values.toList();
  }

  List<ProductHiveModel> getProductsByShopId(String shopId) {
    return _productBox.values
        .where(
          (product) =>
              product.shopId == shopId || product.shopIds.contains(shopId),
        )
        .toList();
  }

  List<ProductHiveModel> getProductsByCategoryId(String categoryId) {
    return _productBox.values
        .where(
          (product) =>
              product.categoryId == categoryId ||
              (product.categoryIds?.contains(categoryId) ?? false),
        )
        .toList();
  }

  Future<bool> updateProduct(String id, ProductHiveModel product) async {
    if (_productBox.containsKey(id)) {
      await _productBox.put(id, product);
      return true;
    }
    return false;
  }

  Future<bool> deleteProduct(String id) async {
    await _productBox.delete(id);
    return true;
  }

  Future<void> deleteAllProducts() async {
    await _productBox.clear();
  }

  // ======================= Shop Queries =========================

  Box<ShopHiveModel> get _shopBox =>
      Hive.box<ShopHiveModel>(HiveTableConstant.shopsTable);

  Future<ShopHiveModel> createShop(ShopHiveModel shop) async {
    final key = shop.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    shop = ShopHiveModel(
      id: key,
      name: shop.name,
      pickupInfo: shop.pickupInfo,
      about: shop.about,
      acceptsSubscription: shop.acceptsSubscription,
      addressId: shop.addressId,
      userId: shop.userId,
      categoryId: shop.categoryId,
    );
    await _shopBox.put(shop.id, shop);
    return shop;
  }

  ShopHiveModel? getShopById(String id) {
    final shop = _shopBox.get(id);
    if (shop != null) {
      return _populateShopRelations(shop);
    }
    return null;
  }

  List<ShopHiveModel> getAllShops() {
    return _shopBox.values.map((shop) => _populateShopRelations(shop)).toList();
  }

  List<ShopHiveModel> getShopsByUserId(String userId) {
    return _shopBox.values
        .where((shop) => shop.userId == userId)
        .map((shop) => _populateShopRelations(shop))
        .toList();
  }

  List<ShopHiveModel> getShopsByCategoryId(String categoryId) {
    return _shopBox.values
        .where((shop) => shop.categoryId == categoryId)
        .map((shop) => _populateShopRelations(shop))
        .toList();
  }

  // Helper method to populate shop relations (address and category)
  ShopHiveModel _populateShopRelations(ShopHiveModel shop) {
    String? addressLabel = shop.addressLabel;
    String? addressLine1 = shop.addressLine1;
    String? categoryName = shop.categoryName;

    if (shop.addressId != null &&
        (addressLabel == null || addressLine1 == null)) {
      final address = getAddressById(shop.addressId!);
      addressLabel = address?.label;
      addressLine1 = address?.line1;
    }

    if (shop.categoryId != null && categoryName == null) {
      final category = getShopCategoryById(shop.categoryId!);
      categoryName = category?.name;
    }

    return ShopHiveModel(
      id: shop.id,
      name: shop.name,
      pickupInfo: shop.pickupInfo,
      about: shop.about,
      acceptsSubscription: shop.acceptsSubscription,
      addressId: shop.addressId,
      shopBanner: shop.shopBanner,
      userId: shop.userId,
      categoryId: shop.categoryId,
      addressLabel: addressLabel,
      addressLine1: addressLine1,
      categoryName: categoryName,
    );
  }

  Future<bool> updateShop(String id, ShopHiveModel shop) async {
    if (_shopBox.containsKey(id)) {
      await _shopBox.put(id, shop);
      return true;
    }
    return false;
  }

  Future<bool> deleteShop(String id) async {
    await _shopBox.delete(id);
    return true;
  }

  Future<void> deleteAllShops() async {
    await _shopBox.clear();
  }

  // ======================= Subscription Queries =========================

  Box<SubscriptionHiveModel> get _subscriptionBox =>
      Hive.box<SubscriptionHiveModel>(HiveTableConstant.subscriptionsTable);

  Future<SubscriptionHiveModel> createSubscription(
    SubscriptionHiveModel subscription,
  ) async {
    await _subscriptionBox.put(subscription.id, subscription);
    return subscription;
  }

  SubscriptionHiveModel? getSubscriptionById(String id) {
    final subscription = _subscriptionBox.get(id);
    if (subscription != null && subscription.subscriptionPlanId != null) {
      // Ensure subscription plan with products is loaded
      _populateSubscriptionPlanProducts(subscription.subscriptionPlanId!);
    }
    return subscription;
  }

  List<SubscriptionHiveModel> getAllSubscriptions() {
    final subscriptions = _subscriptionBox.values.toList();
    // Preload all subscription plans with their products
    for (final subscription in subscriptions) {
      if (subscription.subscriptionPlanId != null) {
        _populateSubscriptionPlanProducts(subscription.subscriptionPlanId!);
      }
    }
    return subscriptions;
  }

  List<SubscriptionHiveModel> getSubscriptionsByUserId(String userId) {
    final subscriptions = _subscriptionBox.values
        .where((subscription) => subscription.userId == userId)
        .toList();
    // Preload subscription plans with their products
    for (final subscription in subscriptions) {
      if (subscription.subscriptionPlanId != null) {
        _populateSubscriptionPlanProducts(subscription.subscriptionPlanId!);
      }
    }
    return subscriptions;
  }

  List<SubscriptionHiveModel> getSubscriptionsByShopId(String shopId) {
    final subscriptions = _subscriptionBox.values
        .where((subscription) => subscription.shopId == shopId)
        .toList();
    // Preload subscription plans with their products
    for (final subscription in subscriptions) {
      if (subscription.subscriptionPlanId != null) {
        _populateSubscriptionPlanProducts(subscription.subscriptionPlanId!);
      }
    }
    return subscriptions;
  }

  // Helper to ensure products are accessible from subscription plan
  SubscriptionPlanHiveModel? _populateSubscriptionPlanProducts(String planId) {
    final plan = _subscriptionPlanBox.get(planId);
    if (plan != null &&
        plan.productIds != null &&
        plan.productIds!.isNotEmpty) {
      // Verify products exist and are accessible
      for (final productId in plan.productIds!) {
        getProductById(productId);
      }
    }
    return plan;
  }

  Future<bool> updateSubscription(
    String id,
    SubscriptionHiveModel subscription,
  ) async {
    if (_subscriptionBox.containsKey(id)) {
      await _subscriptionBox.put(id, subscription);
      return true;
    }
    return false;
  }

  Future<bool> deleteSubscription(String id) async {
    await _subscriptionBox.delete(id);
    return true;
  }

  Future<void> deleteAllSubscriptions() async {
    await _subscriptionBox.clear();
  }

  // ======================= Subscription Plan Queries =========================

  Box<SubscriptionPlanHiveModel> get _subscriptionPlanBox =>
      Hive.box<SubscriptionPlanHiveModel>(
        HiveTableConstant.subscriptionPlansTable,
      );

  Future<SubscriptionPlanHiveModel> createSubscriptionPlan(
    SubscriptionPlanHiveModel subscriptionPlan,
  ) async {
    await _subscriptionPlanBox.put(subscriptionPlan.id, subscriptionPlan);
    return subscriptionPlan;
  }

  SubscriptionPlanHiveModel? getSubscriptionPlanById(String id) {
    return _populateSubscriptionPlanProducts(id);
  }

  List<SubscriptionPlanHiveModel> getAllSubscriptionPlans() {
    return _subscriptionPlanBox.values.map((plan) {
      if (plan.id != null) {
        return _populateSubscriptionPlanProducts(plan.id!) ?? plan;
      }
      return plan;
    }).toList();
  }

  List<SubscriptionPlanHiveModel> getSubscriptionPlansByShopId(String shopId) {
    // Get all subscriptions for this shop, then get their subscription plans
    final subscriptions = _subscriptionBox.values
        .where((subscription) => subscription.shopId == shopId)
        .toList();
    final planIds = subscriptions
        .map((s) => s.subscriptionPlanId)
        .whereType<String>()
        .toSet();
    return planIds
        .map((id) => _populateSubscriptionPlanProducts(id))
        .whereType<SubscriptionPlanHiveModel>()
        .toList();
  }

  Future<bool> updateSubscriptionPlan(
    String id,
    SubscriptionPlanHiveModel subscriptionPlan,
  ) async {
    if (_subscriptionPlanBox.containsKey(id)) {
      await _subscriptionPlanBox.put(id, subscriptionPlan);
      return true;
    }
    return false;
  }

  Future<bool> deleteSubscriptionPlan(String id) async {
    await _subscriptionPlanBox.delete(id);
    return true;
  }

  Future<void> deleteAllSubscriptionPlans() async {
    await _subscriptionPlanBox.clear();
  }
}
