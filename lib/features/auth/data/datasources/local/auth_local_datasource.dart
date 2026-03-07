import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/data/datasources/auth_datasource.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

//provider

final authLocalDatasourceProvider = Provider<IAuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final userSessionService = ref.watch(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final UserSessionService _userSessionService;
  final HiveService _hiveService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<UserHiveModel?> getCurrentUser(String userId) {
    try {
      final user = _hiveService.getCurrentUser(userId);
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<UserHiveModel?> login(String email, String password) async {
    try {
      final user = _hiveService.login(email, password);
      if (user != null) {
        await _userSessionService.saveUserSession(
          userId: user.userId ?? '',
          email: user.email ?? '',
          username: user.userName ?? '',
          role: user.role ?? '',
        );
        return Future.value(user);
      }
      return Future.value(null);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout(String userId) async {
    try {
      await _hiveService.logout(userId);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<UserHiveModel?> register(UserHiveModel model) async {
    try {
      final user = await _hiveService.register(model);
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> updateUserByEmail(String email, UserHiveModel updateData) {
    try {
      final result = _hiveService.updateUserByEmail(email, updateData);
      return Future.value(result);
    } catch (e) {
      return Future.value(false);
    }
  }
}
