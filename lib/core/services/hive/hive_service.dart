import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
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
  }

  // Adapter register
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  // box open
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    // await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
    // await Hive.openBox<AuthHiveModel>(HiveTableConstant.studentTable);
    // await Hive.openBox<ItemHiveModel>(HiveTableConstant.itemTable);
    // await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
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
    await _authBox.put(user.userId, user);
    return user;
  }

  // Login - find user by email and password
  UserHiveModel? login(String email, String password) {
    // try {
    //   return _authBox.values.firstWhere(
    //     (user) => user.email == email && user.password == password,
    //   );
    // } catch (e) {
    //   return null;
    // }
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
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

  // Get user by email
  UserHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Update user
  Future<bool> updateUser(UserHiveModel user) async {
    if (_authBox.containsKey(user.userId)) {
      await _authBox.put(user.userId, user);
      return true;
    }
    return false;
  }

  // Delete user
  Future<bool> deleteUser(String authId) async {
    await _authBox.delete(authId);
    return true;
  }

  // Update user by email
  bool updateUserByEmail(String email, UserHiveModel updateData) {
    try {
      final user = getUserByEmail(email);
      if (user != null) {
        final updatedUser = UserHiveModel(
          userId: user.userId,
          role: updateData.role ?? user.role,
        );
        _authBox.put(updatedUser.userId, updatedUser);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
