import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/auth/data/datasources/auth_datasource.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

//provider

final authLocalDatasourceProvider = Provider<IAuthDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<UserHiveModel> getCurrentUser(String userId) {
    try {
      final user = _hiveService.getCurrentUser(userId);
      return Future.value(user);
    } catch (e) {
      throw Exception('Get current user failed');
    }
  }

  @override
  Future<UserHiveModel> login(String email, String password) async {
    try {
      final user = _hiveService.login(email, password);
      return Future.value(user);
    } catch (e) {
      throw Exception('Login failed');
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
  Future<bool> register(UserHiveModel model) async {
    try {
      await _hiveService.register(model);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
