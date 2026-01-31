import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

void main() {
  group('HiveService Tests', () {
    late HiveService hiveService;
    late Box<UserHiveModel> userBox;

    setUpAll(() async {
      // Initialize Hive for testing
      Hive.init('./test/.hive');

      // Register adapter
      if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
        Hive.registerAdapter(UserHiveModelAdapter());
      }

      // Open box
      userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    });

    setUp(() {
      hiveService = HiveService();
    });

    tearDown(() async {
      // Clear box after each test
      await userBox.clear();
    });

    tearDownAll(() async {
      // Clean up after all tests
      await Hive.close();
    });

    test('register - should save user to hive box', () async {
      final user = UserHiveModel(
        userId: 'user123',
        email: 'test@example.com',
        userName: 'testuser',
        password: 'password123',
        role: 'customer',
      );

      final result = await hiveService.register(user);

      expect(result, isNotNull);
      expect(result?.userId, equals('user123'));
      expect(result?.email, equals('test@example.com'));
      expect(userBox.containsKey('user123'), isTrue);
    });

    test('login - should return user when email and password match', () async {
      final user = UserHiveModel(
        userId: 'user456',
        email: 'john@example.com',
        userName: 'john_doe',
        password: 'pass123',
        fullName: 'John Doe',
        role: 'customer',
      );
      await hiveService.register(user);

      final result = hiveService.login('john@example.com', 'pass123');

      expect(result, isNotNull);
      expect(result?.email, equals('john@example.com'));
      expect(result?.userName, equals('john_doe'));
    });

    test('getCurrentUser - should retrieve user by userId', () async {
      final user = UserHiveModel(
        userId: 'user789',
        email: 'user@example.com',
        userName: 'username',
        password: 'pass',
        fullName: 'Test User',
      );
      await hiveService.register(user);

      final result = hiveService.getCurrentUser('user789');

      expect(result, isNotNull);
      expect(result?.userId, equals('user789'));
      expect(result?.fullName, equals('Test User'));
    });

    test('updateUser - should update existing user successfully', () async {
      final user = UserHiveModel(
        userId: 'user999',
        email: 'original@example.com',
        userName: 'originaluser',
        password: 'oldpass',
        fullName: 'Original Name',
      );
      await hiveService.register(user);

      final updatedUser = UserHiveModel(
        userId: 'user999',
        email: 'updated@example.com',
        userName: 'updateduser',
        password: 'newpass',
        fullName: 'Updated Name',
        role: 'admin',
      );

      final result = await hiveService.updateUser(updatedUser);
      expect(result, isTrue);
      final retrievedUser = hiveService.getCurrentUser('user999');
      expect(retrievedUser?.email, equals('updated@example.com'));
      expect(retrievedUser?.fullName, equals('Updated Name'));
    });

    test('getUserByEmail - should find user by email address', () async {
      final user = UserHiveModel(
        userId: 'user111',
        email: 'search@example.com',
        userName: 'searcher',
        password: 'pass',
        profilePictureUrl: 'https://example.com/pic.jpg',
      );
      await hiveService.register(user);

      final result = hiveService.getUserByEmail('search@example.com');

      expect(result, isNotNull);
      expect(result?.userId, equals('user111'));
      expect(result?.profilePictureUrl, equals('https://example.com/pic.jpg'));
    });
  });
}
