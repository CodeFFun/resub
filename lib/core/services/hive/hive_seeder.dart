import 'dart:math';

import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
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

class HiveSeeder {
  HiveSeeder._();

  static const String vendorId1 = '69931cadbdb67cec3d290c23';
  static const String vendorId2 = '697dbeb89e90001cff960ed5';
  static const String customerId = '697dfd29477a1cdb684fdcd8';

  static Future<void> seedDatabase() async {
    _ensureBoxesOpen();

    // Check if database is already seeded
    final userBox = Hive.box<UserHiveModel>(HiveTableConstant.userTable);
    if (userBox.isNotEmpty) {
      print('HiveSeeder: Database already seeded, skipping...');
      return;
    }

    print('HiveSeeder: Seeding database...');
    final random = Random(42);

    await deleteSeededData();

    final addressBox = Hive.box<AddressHiveModel>(
      HiveTableConstant.addressTable,
    );
    final shopCategoryBox = Hive.box<ShopCategoryHiveModel>(
      HiveTableConstant.shopCategoriesTable,
    );
    final shopBox = Hive.box<ShopHiveModel>(HiveTableConstant.shopsTable);
    final productCategoryBox = Hive.box<ProductCategoryHiveModel>(
      HiveTableConstant.productCategoriesTable,
    );
    final productBox = Hive.box<ProductHiveModel>(
      HiveTableConstant.productsTable,
    );
    final orderItemBox = Hive.box<OrderItemHiveModel>(
      HiveTableConstant.orderItemsTable,
    );
    final orderBox = Hive.box<OrderHiveModel>(HiveTableConstant.orderTable);
    final subscriptionPlanBox = Hive.box<SubscriptionPlanHiveModel>(
      HiveTableConstant.subscriptionPlansTable,
    );
    final subscriptionBox = Hive.box<SubscriptionHiveModel>(
      HiveTableConstant.subscriptionsTable,
    );
    final paymentBox = Hive.box<PaymentHiveModel>(
      HiveTableConstant.paymentsTable,
    );

    // 1) user
    final users = <UserHiveModel>[
      UserHiveModel(
        userId: '697dbeb89e90001cff960ed5',
        email: 'sanket@gmail.com',
        password: 'Sanket@2',
        userName: 'sanket',
        role: 'shop',
        alternateEmail: 'ssass@gmail.com',
        fullName: 'ram Sharma',
        phoneNumber: '98763192182321',
        profilePictureUrl: '/',
      ),
      UserHiveModel(
        userId: '697dfc5e477a1cdb684fdccf',
        email: 'admin@gmail.com',
        password: 'admin@123',
        userName: 'admin',
        role: 'admin',
      ),
      UserHiveModel(
        userId: '697dfd29477a1cdb684fdcd8',
        email: 'aloo@gmail.com',
        password: 'alooaloo',
        userName: 'aloo',
        role: 'customer',
        phoneNumber: '+977 9840030334',
        alternateEmail: 'aloo121@gmail.com',
        fullName: 'sddaawwa Sharma',
        profilePictureUrl: '/',
      ),
      UserHiveModel(
        userId: '69931cadbdb67cec3d290c23',
        email: 'shop@gmail.com',
        password: 'shopshop',
        userName: 'shop',
        role: 'shop',
      ),
    ];
    await userBox.putAll({for (final user in users) user.userId!: user});

    // 2) shopcategory
    final shopCategories = <ShopCategoryHiveModel>[];
    for (var i = 0; i < _shopCategoriesData.length; i++) {
      final id = 'shop-category-${i + 1}';
      final category = _shopCategoriesData[i];
      shopCategories.add(
        ShopCategoryHiveModel(
          id: id,
          name: category['name'],
          description: category['description'],
        ),
      );
    }
    await shopCategoryBox.putAll({
      for (final category in shopCategories) category.id!: category,
    });

    // 3) address
    final addresses = <AddressHiveModel>[];
    for (var i = 0; i < _addressesData.length; i++) {
      final address = _addressesData[i];
      addresses.add(
        AddressHiveModel(
          id: 'address-${i + 1}',
          label: address['label'],
          line1: address['line1'],
          city: address['city'],
          state: address['state'],
          country: address['country'],
          userId: address['userId'],
        ),
      );
    }
    await addressBox.putAll({
      for (final address in addresses) address.id!: address,
    });

    // 4) shop
    final shops = <ShopHiveModel>[];
    var shopIndex = 0;
    const shopCategoryAssignments = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 0];

    for (var i = 0; i < 2; i++) {
      final userId = i == 0 ? vendorId1 : vendorId2;
      final userAddresses = addresses.where((a) => a.userId == userId).toList();
      for (var j = 0; j < 5; j++) {
        final address = userAddresses[j % userAddresses.length];
        final category = shopCategories[shopCategoryAssignments[shopIndex]];
        final id = 'shop-${shopIndex + 1}';
        shops.add(
          ShopHiveModel(
            id: id,
            name: _shopNames[shopIndex],
            pickupInfo: 'Pickup available at ${address.line1}',
            about:
                'Welcome to ${_shopNames[shopIndex]}! We offer quality products with excellent customer service.',
            acceptsSubscription: true,
            addressId: address.id,
            shopBanner: _shopBanners[shopIndex % _shopBanners.length],
            userId: userId,
            categoryId: category.id,
            addressLabel: address.label,
            addressLine1: address.line1,
            categoryName: category.name,
          ),
        );
        shopIndex++;
      }
    }
    await shopBox.putAll({for (final shop in shops) shop.id!: shop});

    // 5) product-category
    final productCategories = <ProductCategoryHiveModel>[];
    final categoriesByShopId = <String, List<ProductCategoryHiveModel>>{};
    for (var i = 0; i < shops.length; i++) {
      final shop = shops[i];
      final localCategories = <ProductCategoryHiveModel>[];
      for (var j = 0; j < 5; j++) {
        final id = 'product-category-${i + 1}-${j + 1}';
        final categoryName = _categoryTemplates[i][j];
        final category = ProductCategoryHiveModel(
          id: id,
          name: categoryName,
          description: '$categoryName for ${shop.name}',
          shopId: shop.id,
          shopName: shop.name,
        );
        productCategories.add(category);
        localCategories.add(category);
      }
      categoriesByShopId[shop.id!] = localCategories;
    }
    await productCategoryBox.putAll({
      for (final category in productCategories) category.id!: category,
    });

    // 6) product
    final products = <ProductHiveModel>[];
    for (var i = 0; i < shops.length; i++) {
      final shop = shops[i];
      final localCategories = categoriesByShopId[shop.id!]!;
      for (var k = 0; k < 15; k++) {
        final template = _productTemplates[i][k];
        final randomCategory =
            localCategories[random.nextInt(localCategories.length)];
        final additionalCategory =
            localCategories[random.nextInt(localCategories.length)];
        final discount = random.nextBool()
            ? random.nextInt(30).toDouble()
            : 0.0;

        products.add(
          ProductHiveModel(
            id: 'product-${i + 1}-${k + 1}',
            name: template['name']!,
            description: template['description']!,
            basePrice: double.parse(template['basePrice']!),
            stockQuantity: random.nextInt(101) + 20,
            discount: discount,
            shopIds: <String>[shop.id!],
            categoryId: randomCategory.id!,
            shopId: shop.id,
            categoryIds: <String>[randomCategory.id!, additionalCategory.id!],
            categoryNames: <String?>[
              randomCategory.name,
              additionalCategory.name,
            ].whereType<String>().toList(),
          ),
        );
      }
    }
    await productBox.putAll({
      for (final product in products) product.id!: product,
    });

    final directOrderProductCount = min(12, products.length);
    final subscriptionProducts = products
        .skip(directOrderProductCount)
        .take(min(10, products.length - directOrderProductCount))
        .toList();

    // 7) orderitem
    final orderItems = <OrderItemHiveModel>[];
    final directOrderSeeds = <_DirectOrderSeed>[];
    for (var i = 0; i < directOrderProductCount; i++) {
      final product = products[i];
      final quantity = random.nextInt(3) + 1;
      final discountedPrice = _to2dp(
        product.basePrice * (1 - (product.discount / 100)),
      );
      final orderItemId = 'order-item-${i + 1}';
      orderItems.add(
        OrderItemHiveModel(
          id: orderItemId,
          productId: product.id,
          productName: product.name,
          productBasePrice: product.basePrice,
          productDiscount: product.discount.round(),
          quantity: quantity,
          unitPrice: discountedPrice,
        ),
      );
      directOrderSeeds.add(
        _DirectOrderSeed(
          orderItemId: orderItemId,
          product: product,
          quantity: quantity,
          discountedPrice: discountedPrice,
          orderIndex: i,
        ),
      );
    }
    await orderItemBox.putAll({for (final item in orderItems) item.id!: item});

    // 8) order
    final orders = <OrderHiveModel>[];
    final subscriptionOrderSeeds = <_SubscriptionOrderSeed>[];

    for (final seed in directOrderSeeds) {
      final orderId = 'order-direct-${seed.orderIndex + 1}';
      orders.add(
        OrderHiveModel(
          id: orderId,
          deliveryType: seed.orderIndex.isEven ? 'standard' : 'express',
          scheduleFor: DateTime.now().add(Duration(days: seed.orderIndex + 1)),
          userId: customerId,
          shopId: seed.product.shopId,
          shopName: shops.firstWhere((s) => s.id == seed.product.shopId).name,
          orderItemsIds: <String>[seed.orderItemId],
        ),
      );
    }

    for (var i = 0; i < subscriptionProducts.length; i++) {
      final product = subscriptionProducts[i];
      final orderId = 'order-subscription-${i + 1}';
      orders.add(
        OrderHiveModel(
          id: orderId,
          deliveryType: 'subscription',
          scheduleFor: DateTime.now().add(Duration(days: i + 2)),
          userId: customerId,
          shopId: product.shopId,
          shopName: shops.firstWhere((s) => s.id == product.shopId).name,
          orderItemsIds: null,
          subscriptionId: null,
        ),
      );
      subscriptionOrderSeeds.add(
        _SubscriptionOrderSeed(orderId: orderId, product: product, index: i),
      );
    }
    await orderBox.putAll({for (final order in orders) order.id!: order});

    // 9) subscriptionplan
    final subscriptionPlans = <SubscriptionPlanHiveModel>[];
    final subscriptionSeeds = <_SubscriptionSeed>[];
    const frequencies = <int>[7, 15, 30];

    for (final seed in subscriptionOrderSeeds) {
      final frequency = frequencies[seed.index % frequencies.length];
      final quantity = random.nextInt(2) + 1;
      final cyclePrice = _to2dp(
        seed.product.basePrice * (1 - (seed.product.discount / 100)),
      );
      final planId = 'subscription-plan-${seed.index + 1}';

      subscriptionPlans.add(
        SubscriptionPlanHiveModel(
          id: planId,
          frequency: frequency,
          pricePerCycle: cyclePrice,
          active: true,
          productIds: <String>[seed.product.id!],
          productNames: <String>[seed.product.name],
          productQuantities: <int>[quantity],
          productBasePrices: <num>[seed.product.basePrice],
          productDiscounts: <double>[seed.product.discount.round().toDouble()],
          quantity: quantity,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      subscriptionSeeds.add(
        _SubscriptionSeed(
          planId: planId,
          orderId: seed.orderId,
          product: seed.product,
          frequency: frequency,
          quantity: quantity,
          cyclePrice: cyclePrice,
          index: seed.index,
        ),
      );
    }
    await subscriptionPlanBox.putAll({
      for (final plan in subscriptionPlans) plan.id!: plan,
    });

    // 10) subscription
    final subscriptions = <SubscriptionHiveModel>[];
    final updatedSubscriptionOrders = <OrderHiveModel>[];

    for (final seed in subscriptionSeeds) {
      final subscriptionId = 'subscription-${seed.index + 1}';
      subscriptions.add(
        SubscriptionHiveModel(
          id: subscriptionId,
          status: 'active',
          startDate: DateTime.now(),
          remainingCycle: seed.frequency,
          subscriptionPlanId: seed.planId,
          userId: customerId,
          shopId: seed.product.shopId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final existingOrder = orders.firstWhere((o) => o.id == seed.orderId);
      updatedSubscriptionOrders.add(
        OrderHiveModel(
          id: existingOrder.id,
          deliveryType: existingOrder.deliveryType,
          scheduleFor: existingOrder.scheduleFor,
          userId: existingOrder.userId,
          shopId: existingOrder.shopId,
          shopName: existingOrder.shopName,
          orderItemsIds: existingOrder.orderItemsIds,
          subscriptionId: subscriptionId,
        ),
      );
    }

    await subscriptionBox.putAll({
      for (final subscription in subscriptions) subscription.id!: subscription,
    });
    await orderBox.putAll({
      for (final order in updatedSubscriptionOrders) order.id!: order,
    });

    // 11) payment
    final payments = <PaymentHiveModel>[];

    for (final seed in directOrderSeeds) {
      final orderId = 'order-direct-${seed.orderIndex + 1}';
      final shopId = seed.product.shopId;
      payments.add(
        PaymentHiveModel(
          id: 'payment-direct-${seed.orderIndex + 1}',
          provider: seed.orderIndex % 3 == 0 ? 'khalti' : 'esewa',
          status: 'completed',
          amount: _to2dp(seed.discountedPrice * seed.quantity),
          paidAt: DateTime.now(),
          orderId: <String>[orderId],
          userId: customerId,
          shopId: shopId,
          orderItemsId: <String>[seed.orderItemId],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    final subscriptionsById = {for (final sub in subscriptions) sub.id!: sub};
    final updatedSubscriptions = <SubscriptionHiveModel>[];

    for (final seed in subscriptionSeeds) {
      final orderId = seed.orderId;
      final subscriptionId = 'subscription-${seed.index + 1}';
      final paymentId = 'payment-subscription-${seed.index + 1}';
      payments.add(
        PaymentHiveModel(
          id: paymentId,
          provider: 'esewa',
          status: 'completed',
          amount: _to2dp(seed.cyclePrice * seed.quantity),
          paidAt: DateTime.now(),
          orderId: <String>[orderId],
          subscriptionId: subscriptionId,
          userId: customerId,
          shopId: seed.product.shopId,
          orderItemsId: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final subscription = subscriptionsById[subscriptionId]!;
      updatedSubscriptions.add(
        SubscriptionHiveModel(
          id: subscription.id,
          status: subscription.status,
          remainingCycle: subscription.remainingCycle,
          subscriptionPlanId: subscription.subscriptionPlanId,
          startDate: subscription.startDate,
          shopId: subscription.shopId,
          userId: subscription.userId,
          paymentId: paymentId,
          createdAt: subscription.createdAt,
          updatedAt: DateTime.now(),
        ),
      );
    }

    await paymentBox.putAll({
      for (final payment in payments) payment.id!: payment,
    });
    await subscriptionBox.putAll({
      for (final subscription in updatedSubscriptions)
        subscription.id!: subscription,
    });

    print('HiveSeeder: Database seeding completed successfully');
    print('  - ${userBox.length} users');
    print('  - ${orderBox.length} orders');
    print('  - ${orderItemBox.length} order items');
  }

  static Future<void> deleteSeededData() async {
    _ensureBoxesOpen();

    await Hive.box<PaymentHiveModel>(HiveTableConstant.paymentsTable).clear();
    await Hive.box<SubscriptionHiveModel>(
      HiveTableConstant.subscriptionsTable,
    ).clear();
    await Hive.box<SubscriptionPlanHiveModel>(
      HiveTableConstant.subscriptionPlansTable,
    ).clear();
    await Hive.box<OrderHiveModel>(HiveTableConstant.orderTable).clear();
    await Hive.box<OrderItemHiveModel>(
      HiveTableConstant.orderItemsTable,
    ).clear();
    await Hive.box<ProductHiveModel>(HiveTableConstant.productsTable).clear();
    await Hive.box<ProductCategoryHiveModel>(
      HiveTableConstant.productCategoriesTable,
    ).clear();
    await Hive.box<ShopHiveModel>(HiveTableConstant.shopsTable).clear();
    await Hive.box<AddressHiveModel>(HiveTableConstant.addressTable).clear();
    await Hive.box<ShopCategoryHiveModel>(
      HiveTableConstant.shopCategoriesTable,
    ).clear();
    await Hive.box<UserHiveModel>(HiveTableConstant.userTable).clear();
  }

  static void _ensureBoxesOpen() {
    final requiredTables = <String>[
      HiveTableConstant.userTable,
      HiveTableConstant.shopCategoriesTable,
      HiveTableConstant.addressTable,
      HiveTableConstant.shopsTable,
      HiveTableConstant.productCategoriesTable,
      HiveTableConstant.productsTable,
      HiveTableConstant.orderItemsTable,
      HiveTableConstant.orderTable,
      HiveTableConstant.subscriptionPlansTable,
      HiveTableConstant.subscriptionsTable,
      HiveTableConstant.paymentsTable,
    ];

    for (final table in requiredTables) {
      if (!Hive.isBoxOpen(table)) {
        throw StateError(
          'Hive box "$table" is not open. Call HiveService.init() before seeding.',
        );
      }
    }
  }

  static double _to2dp(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  static const List<Map<String, String>> _shopCategoriesData = [
    {
      'name': 'Electronics & Technology',
      'description':
          'Shops selling electronic devices, gadgets, and tech accessories',
    },
    {
      'name': 'Fashion & Apparel',
      'description': 'Clothing, footwear, and fashion accessories stores',
    },
    {
      'name': 'Home & Living',
      'description': 'Furniture, home decor, and household essentials',
    },
    {
      'name': 'Food & Beverages',
      'description':
          'Gourmet foods, snacks, beverages, and specialty ingredients',
    },
    {
      'name': 'Sports & Fitness',
      'description': 'Sports equipment, athletic wear, and fitness accessories',
    },
    {
      'name': 'Beauty & Personal Care',
      'description': 'Cosmetics, skincare, and personal care products',
    },
    {
      'name': 'Books & Media',
      'description': 'Books, magazines, music, and entertainment media',
    },
    {
      'name': 'Toys & Games',
      'description': 'Toys, board games, and recreational items',
    },
    {
      'name': 'Automotive',
      'description': 'Car accessories, parts, and automotive supplies',
    },
  ];

  static const List<Map<String, String>> _addressesData = [
    {
      'label': 'Home',
      'line1': '123 Main Street',
      'city': 'New York',
      'state': 'NY',
      'country': 'USA',
      'userId': vendorId1,
    },
    {
      'label': 'Office',
      'line1': '456 Business Ave, Suite 200',
      'city': 'New York',
      'state': 'NY',
      'country': 'USA',
      'userId': vendorId1,
    },
    {
      'label': 'Warehouse',
      'line1': '789 Industrial Pkwy',
      'city': 'Brooklyn',
      'state': 'NY',
      'country': 'USA',
      'userId': vendorId1,
    },
    {
      'label': 'Home',
      'line1': '321 Oak Street',
      'city': 'Los Angeles',
      'state': 'CA',
      'country': 'USA',
      'userId': vendorId2,
    },
    {
      'label': 'Store Location',
      'line1': '654 Commerce Blvd',
      'city': 'Los Angeles',
      'state': 'CA',
      'country': 'USA',
      'userId': vendorId2,
    },
    {
      'label': 'Distribution Center',
      'line1': '987 Logistics Way',
      'city': 'Long Beach',
      'state': 'CA',
      'country': 'USA',
      'userId': vendorId2,
    },
    {
      'label': 'Home',
      'line1': '555 Oak Lane',
      'city': 'Chicago',
      'state': 'IL',
      'country': 'USA',
      'userId': customerId,
    },
    {
      'label': 'Work',
      'line1': '777 Corporate Drive',
      'city': 'Chicago',
      'state': 'IL',
      'country': 'USA',
      'userId': customerId,
    },
    {
      'label': 'Apartment',
      'line1': '999 Residential Ave',
      'city': 'Evanston',
      'state': 'IL',
      'country': 'USA',
      'userId': customerId,
    },
  ];

  static const List<String> _shopBanners = [
    '/uploads/09f18778-6a4a-42cd-a1ca-80858b6aa7af.png',
    '/uploads/155fb0eb-2444-469b-8b13-8c9eff81001b.png',
    '/uploads/2349a112-6f52-4981-b262-c9bc6022c765.png',
    '/uploads/34e24c25-0856-4454-a8bc-869721aecf7c.jpg',
    '/uploads/8ca4abea-b242-4568-8ab3-dbc3ccda53fd.jpg',
    '/uploads/ac672b1e-215e-4cb4-a864-114f9fa7a85d.jpg',
  ];

  static const List<String> _shopNames = [
    'Tech Haven',
    'Fashion Forward',
    'Home Essentials',
    'Gourmet Delights',
    'Sports Zone',
    'Beauty Boutique',
    'Electronics Plus',
    'Trendy Wear',
    'Living Space',
    'Artisan Foods',
  ];

  static const List<List<String>> _categoryTemplates = [
    <String>['Electronics', 'Gadgets', 'Accessories', 'Smart Home', 'Audio'],
    <String>[
      'Men\'s Clothing',
      'Women\'s Clothing',
      'Kids Wear',
      'Footwear',
      'Accessories',
    ],
    <String>['Furniture', 'Decor', 'Kitchen', 'Bedding', 'Storage'],
    <String>['Snacks', 'Beverages', 'Organic', 'Specialty Foods', 'Baking'],
    <String>['Equipment', 'Apparel', 'Footwear', 'Accessories', 'Nutrition'],
    <String>['Skincare', 'Makeup', 'Haircare', 'Fragrances', 'Tools'],
    <String>['Computing', 'Networking', 'Peripherals', 'Storage', 'Monitors'],
    <String>[
      'Casual Wear',
      'Formal Wear',
      'Activewear',
      'Underwear',
      'Accessories',
    ],
    <String>['Outdoor', 'Indoor', 'Lighting', 'Textiles', 'Organization'],
    <String>['Dairy', 'Produce', 'Spices', 'Condiments', 'Beverages'],
  ];

  static const List<List<Map<String, String>>> _productTemplates = [
    <Map<String, String>>[
      {
        'name': 'Wireless Mouse',
        'basePrice': '29.99',
        'description': 'Ergonomic wireless mouse with precision tracking',
      },
      {
        'name': 'USB-C Cable',
        'basePrice': '12.99',
        'description': 'High-speed charging cable 6ft',
      },
      {
        'name': 'Phone Stand',
        'basePrice': '19.99',
        'description': 'Adjustable aluminum phone stand',
      },
      {
        'name': 'Bluetooth Speaker',
        'basePrice': '49.99',
        'description': 'Portable waterproof Bluetooth speaker',
      },
      {
        'name': 'Screen Protector',
        'basePrice': '9.99',
        'description': 'Tempered glass screen protector',
      },
      {
        'name': 'Smart LED Bulb',
        'basePrice': '24.99',
        'description': 'WiFi-enabled color changing bulb',
      },
      {
        'name': 'Wireless Charger',
        'basePrice': '34.99',
        'description': 'Fast wireless charging pad',
      },
      {
        'name': 'Keyboard',
        'basePrice': '69.99',
        'description': 'Mechanical RGB gaming keyboard',
      },
      {
        'name': 'Webcam HD',
        'basePrice': '79.99',
        'description': '1080p HD webcam with microphone',
      },
      {
        'name': 'Power Bank',
        'basePrice': '39.99',
        'description': '20000mAh portable charger',
      },
      {
        'name': 'Earbuds',
        'basePrice': '89.99',
        'description': 'True wireless earbuds with noise cancellation',
      },
      {
        'name': 'Laptop Stand',
        'basePrice': '44.99',
        'description': 'Adjustable aluminum laptop stand',
      },
      {
        'name': 'HDMI Cable',
        'basePrice': '14.99',
        'description': '4K HDMI cable 10ft',
      },
      {
        'name': 'Gaming Mouse Pad',
        'basePrice': '24.99',
        'description': 'Extended RGB gaming mouse pad',
      },
      {
        'name': 'USB Hub',
        'basePrice': '29.99',
        'description': '7-port USB 3.0 hub',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Cotton T-Shirt',
        'basePrice': '24.99',
        'description': 'Premium cotton crew neck t-shirt',
      },
      {
        'name': 'Denim Jeans',
        'basePrice': '59.99',
        'description': 'Classic fit denim jeans',
      },
      {
        'name': 'Leather Jacket',
        'basePrice': '149.99',
        'description': 'Genuine leather motorcycle jacket',
      },
      {
        'name': 'Summer Dress',
        'basePrice': '79.99',
        'description': 'Floral print summer dress',
      },
      {
        'name': 'Running Shoes',
        'basePrice': '89.99',
        'description': 'Lightweight running shoes',
      },
      {
        'name': 'Backpack',
        'basePrice': '49.99',
        'description': 'Water-resistant travel backpack',
      },
      {
        'name': 'Wristwatch',
        'basePrice': '199.99',
        'description': 'Stainless steel analog watch',
      },
      {
        'name': 'Sunglasses',
        'basePrice': '39.99',
        'description': 'UV protection polarized sunglasses',
      },
      {
        'name': 'Hoodie',
        'basePrice': '54.99',
        'description': 'Pullover fleece hoodie',
      },
      {
        'name': 'Sneakers',
        'basePrice': '74.99',
        'description': 'Classic white sneakers',
      },
      {
        'name': 'Belt',
        'basePrice': '29.99',
        'description': 'Genuine leather belt',
      },
      {
        'name': 'Wallet',
        'basePrice': '34.99',
        'description': 'RFID blocking leather wallet',
      },
      {
        'name': 'Scarf',
        'basePrice': '19.99',
        'description': 'Wool blend winter scarf',
      },
      {
        'name': 'Baseball Cap',
        'basePrice': '24.99',
        'description': 'Adjustable cotton cap',
      },
      {
        'name': 'Socks Pack',
        'basePrice': '14.99',
        'description': '6-pack athletic socks',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Bed Sheets Set',
        'basePrice': '49.99',
        'description': 'Premium microfiber bed sheet set',
      },
      {
        'name': 'Throw Pillows',
        'basePrice': '29.99',
        'description': 'Decorative throw pillow pair',
      },
      {
        'name': 'Coffee Table',
        'basePrice': '149.99',
        'description': 'Modern wood coffee table',
      },
      {
        'name': 'Table Lamp',
        'basePrice': '39.99',
        'description': 'Modern minimalist table lamp',
      },
      {
        'name': 'Area Rug',
        'basePrice': '89.99',
        'description': 'Soft shag area rug 5x7',
      },
      {
        'name': 'Storage Bins',
        'basePrice': '24.99',
        'description': 'Collapsible storage bins set of 3',
      },
      {
        'name': 'Wall Art',
        'basePrice': '59.99',
        'description': 'Framed canvas wall art',
      },
      {
        'name': 'Curtains',
        'basePrice': '44.99',
        'description': 'Blackout thermal curtains',
      },
      {
        'name': 'Knife Set',
        'basePrice': '79.99',
        'description': '15-piece kitchen knife set',
      },
      {
        'name': 'Cookware Set',
        'basePrice': '129.99',
        'description': 'Non-stick cookware 10-piece set',
      },
      {
        'name': 'Comforter Set',
        'basePrice': '99.99',
        'description': 'All-season comforter with shams',
      },
      {
        'name': 'Bath Towels',
        'basePrice': '34.99',
        'description': 'Turkish cotton bath towel set',
      },
      {
        'name': 'Trash Can',
        'basePrice': '29.99',
        'description': 'Stainless steel step trash can',
      },
      {
        'name': 'Laundry Basket',
        'basePrice': '19.99',
        'description': 'Collapsible laundry hamper',
      },
      {
        'name': 'Mirror',
        'basePrice': '64.99',
        'description': 'Large wall-mounted mirror',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Organic Coffee Beans',
        'basePrice': '16.99',
        'description': 'Single-origin arabica coffee beans 1lb',
      },
      {
        'name': 'Artisan Chocolate',
        'basePrice': '12.99',
        'description': 'Handcrafted dark chocolate bar',
      },
      {
        'name': 'Olive Oil',
        'basePrice': '19.99',
        'description': 'Extra virgin olive oil 500ml',
      },
      {
        'name': 'Honey',
        'basePrice': '14.99',
        'description': 'Raw organic honey 16oz',
      },
      {
        'name': 'Pasta Set',
        'basePrice': '24.99',
        'description': 'Italian pasta variety pack',
      },
      {
        'name': 'Spice Collection',
        'basePrice': '29.99',
        'description': 'Gourmet spice set 12 bottles',
      },
      {
        'name': 'Green Tea',
        'basePrice': '9.99',
        'description': 'Premium loose leaf green tea',
      },
      {
        'name': 'Trail Mix',
        'basePrice': '8.99',
        'description': 'Organic trail mix 12oz',
      },
      {
        'name': 'Protein Bars',
        'basePrice': '19.99',
        'description': 'Plant-based protein bars 12 pack',
      },
      {
        'name': 'Almond Butter',
        'basePrice': '11.99',
        'description': 'Organic almond butter 16oz',
      },
      {
        'name': 'Quinoa',
        'basePrice': '13.99',
        'description': 'Organic quinoa 2lb bag',
      },
      {
        'name': 'Sea Salt',
        'basePrice': '7.99',
        'description': 'Himalayan pink sea salt',
      },
      {
        'name': 'Balsamic Vinegar',
        'basePrice': '16.99',
        'description': 'Aged balsamic vinegar',
      },
      {
        'name': 'Granola',
        'basePrice': '10.99',
        'description': 'Organic granola cereal',
      },
      {
        'name': 'Dark Roast Coffee',
        'basePrice': '14.99',
        'description': 'Dark roast ground coffee',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Yoga Mat',
        'basePrice': '29.99',
        'description': 'Non-slip exercise yoga mat',
      },
      {
        'name': 'Dumbbells Set',
        'basePrice': '79.99',
        'description': 'Adjustable dumbbell set 50lb',
      },
      {
        'name': 'Resistance Bands',
        'basePrice': '19.99',
        'description': 'Resistance bands set of 5',
      },
      {
        'name': 'Jump Rope',
        'basePrice': '12.99',
        'description': 'Speed jump rope with counter',
      },
      {
        'name': 'Water Bottle',
        'basePrice': '24.99',
        'description': 'Insulated stainless steel 32oz',
      },
      {
        'name': 'Gym Bag',
        'basePrice': '44.99',
        'description': 'Duffel gym bag with shoe compartment',
      },
      {
        'name': 'Running Shorts',
        'basePrice': '29.99',
        'description': 'Lightweight performance shorts',
      },
      {
        'name': 'Sports Bra',
        'basePrice': '34.99',
        'description': 'High impact sports bra',
      },
      {
        'name': 'Foam Roller',
        'basePrice': '24.99',
        'description': 'High density foam roller',
      },
      {
        'name': 'Workout Gloves',
        'basePrice': '19.99',
        'description': 'Padded weight lifting gloves',
      },
      {
        'name': 'Protein Shaker',
        'basePrice': '14.99',
        'description': 'Leak-proof protein shaker bottle',
      },
      {
        'name': 'Fitness Tracker',
        'basePrice': '99.99',
        'description': 'Smart fitness tracker watch',
      },
      {
        'name': 'Compression Socks',
        'basePrice': '22.99',
        'description': 'Athletic compression socks',
      },
      {
        'name': 'Knee Sleeves',
        'basePrice': '29.99',
        'description': 'Compression knee support sleeves',
      },
      {
        'name': 'Tennis Racket',
        'basePrice': '89.99',
        'description': 'Professional tennis racket',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Facial Cleanser',
        'basePrice': '18.99',
        'description': 'Gentle foaming facial cleanser',
      },
      {
        'name': 'Moisturizer',
        'basePrice': '32.99',
        'description': 'Hydrating daily moisturizer SPF 30',
      },
      {
        'name': 'Serum',
        'basePrice': '44.99',
        'description': 'Vitamin C brightening serum',
      },
      {
        'name': 'Face Mask Set',
        'basePrice': '24.99',
        'description': 'Sheet mask variety pack 10 pieces',
      },
      {
        'name': 'Lipstick',
        'basePrice': '19.99',
        'description': 'Long-lasting matte lipstick',
      },
      {
        'name': 'Mascara',
        'basePrice': '16.99',
        'description': 'Volumizing mascara waterproof',
      },
      {
        'name': 'Foundation',
        'basePrice': '36.99',
        'description': 'Full coverage liquid foundation',
      },
      {
        'name': 'Eyeshadow Palette',
        'basePrice': '42.99',
        'description': 'Neutral eyeshadow palette 16 colors',
      },
      {
        'name': 'Nail Polish Set',
        'basePrice': '29.99',
        'description': 'Gel nail polish set 6 colors',
      },
      {
        'name': 'Hair Dryer',
        'basePrice': '79.99',
        'description': 'Ionic hair dryer 1800W',
      },
      {
        'name': 'Flat Iron',
        'basePrice': '69.99',
        'description': 'Ceramic straightening flat iron',
      },
      {
        'name': 'Shampoo',
        'basePrice': '22.99',
        'description': 'Sulfate-free moisturizing shampoo',
      },
      {
        'name': 'Conditioner',
        'basePrice': '22.99',
        'description': 'Repairing hair conditioner',
      },
      {
        'name': 'Perfume',
        'basePrice': '64.99',
        'description': 'Floral eau de parfum 50ml',
      },
      {
        'name': 'Makeup Brushes',
        'basePrice': '39.99',
        'description': 'Professional makeup brush set 12pc',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'External SSD',
        'basePrice': '99.99',
        'description': '1TB portable external SSD',
      },
      {
        'name': 'USB 3.0 Cable',
        'basePrice': '9.99',
        'description': 'High-speed USB 3.0 cable',
      },
      {
        'name': 'Monitor Stand',
        'basePrice': '49.99',
        'description': 'Adjustable monitor stand riser',
      },
      {
        'name': 'Router',
        'basePrice': '89.99',
        'description': 'Dual-band WiFi 6 router',
      },
      {
        'name': 'USB Docking Station',
        'basePrice': '59.99',
        'description': 'Multi-port USB docking station',
      },
      {
        'name': 'Memory Card Reader',
        'basePrice': '14.99',
        'description': 'Multi-card memory reader',
      },
      {
        'name': 'HDMI Splitter',
        'basePrice': '24.99',
        'description': '4K HDMI 1x2 splitter',
      },
      {
        'name': 'USB Extension Cable',
        'basePrice': '12.99',
        'description': '30ft active USB extension',
      },
      {
        'name': 'Network Cable',
        'basePrice': '8.99',
        'description': 'Cat6 ethernet cable 50ft',
      },
      {
        'name': 'Surge Protector',
        'basePrice': '34.99',
        'description': '6-outlet surge protector',
      },
      {
        'name': 'Hard Drive External',
        'basePrice': '79.99',
        'description': '2TB external hard drive',
      },
      {
        'name': 'USB Cable Set',
        'basePrice': '19.99',
        'description': 'USB cable variety pack',
      },
      {
        'name': 'Display Cable',
        'basePrice': '16.99',
        'description': 'DisplayPort 1.4 cable',
      },
      {
        'name': 'Cooling Pad',
        'basePrice': '44.99',
        'description': 'Laptop cooling pad RGB',
      },
      {
        'name': 'Cable Organizer',
        'basePrice': '11.99',
        'description': 'Cable management kit',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Blazer',
        'basePrice': '99.99',
        'description': 'Professional blazer jacket',
      },
      {
        'name': 'Chinos',
        'basePrice': '54.99',
        'description': 'Slim fit chino pants',
      },
      {
        'name': 'Polo Shirt',
        'basePrice': '34.99',
        'description': 'Classic polo shirt',
      },
      {
        'name': 'Cargo Pants',
        'basePrice': '64.99',
        'description': 'Multi-pocket cargo pants',
      },
      {
        'name': 'Thermal Wear',
        'basePrice': '29.99',
        'description': 'Base layer thermal set',
      },
      {
        'name': 'Rain Jacket',
        'basePrice': '84.99',
        'description': 'Waterproof breathable jacket',
      },
      {
        'name': 'Winter Boots',
        'basePrice': '119.99',
        'description': 'Insulated winter boots',
      },
      {
        'name': 'Sweater',
        'basePrice': '59.99',
        'description': 'V-neck wool sweater',
      },
      {
        'name': 'Board Shorts',
        'basePrice': '44.99',
        'description': 'Quick-dry board shorts',
      },
      {
        'name': 'Leggings',
        'basePrice': '39.99',
        'description': 'Yoga leggings with pockets',
      },
      {
        'name': 'Tank Top',
        'basePrice': '19.99',
        'description': 'Breathable tank top',
      },
      {
        'name': 'Cardigan',
        'basePrice': '69.99',
        'description': 'Open-front cardigan sweater',
      },
      {
        'name': 'Denim Shorts',
        'basePrice': '44.99',
        'description': 'Distressed denim shorts',
      },
      {
        'name': 'Thermal Socks',
        'basePrice': '14.99',
        'description': 'Merino wool thermal socks',
      },
      {
        'name': 'Athletic Tights',
        'basePrice': '49.99',
        'description': 'Compression athletic tights',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Desk Chair',
        'basePrice': '199.99',
        'description': 'Ergonomic office desk chair',
      },
      {
        'name': 'Bookshelf',
        'basePrice': '129.99',
        'description': '5-tier wooden bookshelf',
      },
      {
        'name': 'Nightstand',
        'basePrice': '89.99',
        'description': 'Wood nightstand with drawer',
      },
      {
        'name': 'Wall Clock',
        'basePrice': '34.99',
        'description': 'Modern minimalist wall clock',
      },
      {
        'name': 'Desk Organizer',
        'basePrice': '24.99',
        'description': 'Bamboo desk organizer set',
      },
      {
        'name': 'Floor Lamp',
        'basePrice': '59.99',
        'description': 'Arc floor lamp with dimmer',
      },
      {
        'name': 'Wall Shelves',
        'basePrice': '49.99',
        'description': 'Floating wall shelf set of 3',
      },
      {
        'name': 'Curtain Rods',
        'basePrice': '39.99',
        'description': 'Adjustable curtain rod 48-120in',
      },
      {
        'name': 'Room Divider',
        'basePrice': '79.99',
        'description': '4-panel room divider screen',
      },
      {
        'name': 'Ottoman',
        'basePrice': '69.99',
        'description': 'Upholstered storage ottoman',
      },
      {
        'name': 'Picture Frames',
        'basePrice': '19.99',
        'description': 'Frame set 5 different sizes',
      },
      {
        'name': 'Desk Pad',
        'basePrice': '29.99',
        'description': 'Large leather desk pad',
      },
      {
        'name': 'Throw Blanket',
        'basePrice': '44.99',
        'description': 'Chunky knit throw blanket',
      },
      {
        'name': 'Wall Decals',
        'basePrice': '14.99',
        'description': 'Removable wall decal set',
      },
      {
        'name': 'Door Mat',
        'basePrice': '22.99',
        'description': 'Memory foam door mat',
      },
    ],
    <Map<String, String>>[
      {
        'name': 'Maple Syrup',
        'basePrice': '18.99',
        'description': 'Pure maple syrup 12oz',
      },
      {
        'name': 'Truffle Oil',
        'basePrice': '24.99',
        'description': 'Black truffle infused oil',
      },
      {
        'name': 'Vanilla Beans',
        'basePrice': '16.99',
        'description': 'Madagascar vanilla beans',
      },
      {
        'name': 'Saffron',
        'basePrice': '22.99',
        'description': 'Pure saffron threads 1g',
      },
      {
        'name': 'Wild Rice',
        'basePrice': '12.99',
        'description': 'Organic wild rice 1lb',
      },
      {
        'name': 'Specialty Flour',
        'basePrice': '10.99',
        'description': 'Almond flour 2lb bag',
      },
      {
        'name': 'Balsamic Reduction',
        'basePrice': '15.99',
        'description': 'Balsamic glaze 8.5oz',
      },
      {
        'name': 'Nut Butter',
        'basePrice': '13.99',
        'description': 'Cashew butter 16oz',
      },
      {
        'name': 'Sea Vegetables',
        'basePrice': '11.99',
        'description': 'Nori seaweed sheets',
      },
      {
        'name': 'Herbal Tea',
        'basePrice': '9.99',
        'description': 'Chamomile herbal tea bags',
      },
      {
        'name': 'Honey Comb',
        'basePrice': '17.99',
        'description': 'Raw honeycomb chunks',
      },
      {
        'name': 'Dried Fruits',
        'basePrice': '13.99',
        'description': 'Mixed dried fruits 2lb',
      },
      {
        'name': 'Artisan Nuts',
        'basePrice': '19.99',
        'description': 'Roasted nuts assortment',
      },
      {
        'name': 'Vinegar Selection',
        'basePrice': '21.99',
        'description': 'Artisan vinegar trio',
      },
      {
        'name': 'Gourmet Salt',
        'basePrice': '12.99',
        'description': 'Gourmet sea salt collection',
      },
    ],
  ];
}

class _DirectOrderSeed {
  const _DirectOrderSeed({
    required this.orderItemId,
    required this.product,
    required this.quantity,
    required this.discountedPrice,
    required this.orderIndex,
  });

  final String orderItemId;
  final ProductHiveModel product;
  final int quantity;
  final double discountedPrice;
  final int orderIndex;
}

class _SubscriptionOrderSeed {
  const _SubscriptionOrderSeed({
    required this.orderId,
    required this.product,
    required this.index,
  });

  final String orderId;
  final ProductHiveModel product;
  final int index;
}

class _SubscriptionSeed {
  const _SubscriptionSeed({
    required this.planId,
    required this.orderId,
    required this.product,
    required this.frequency,
    required this.quantity,
    required this.cyclePrice,
    required this.index,
  });

  final String planId;
  final String orderId;
  final ProductHiveModel product;
  final int frequency;
  final int quantity;
  final double cyclePrice;
  final int index;
}
