import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/data/datasources/auth_datasource.dart';
import 'package:resub/features/user/data/models/user_api_model.dart';

// Create provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService,
       _userSessionService = userSessionService;

  @override
  Future<UserApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserApiModel.fromJson(data);
      final token = response.data['token'] as String;
      await _userSessionService.saveUserSession(
        userId: user.userId ?? '',
        email: user.email ?? '',
        username: user.username ?? '',
        role: user.role ?? '',
      );
      await _tokenService.saveToken(token);
      return user;
    }

    return null;
  }

  @override
  Future<UserApiModel> register(UserApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = UserApiModel.fromJson(data);
      // await _userSessionService.saveUserSession(
      //   userId: registeredUser.userId ?? '',
      //   email: registeredUser.email ?? '',
      //   username: registeredUser.username ?? '',
      //   role: registeredUser.role ?? '',
      // );
      return registeredUser;
    }

    return user;
  }

  @override
  Future<bool> updateUserByEmail(String email, UserApiModel updateData) async {
    final sendData = updateData.toJson();
    sendData['email'] = email;
    final response = await _apiClient.patch(
      ApiEndpoints.updateUserByEmail,
      data: sendData,
    );
    return response.data['success'];
  }
}
