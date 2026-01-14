import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/data/datasources/auth_datasource.dart';
import 'package:resub/features/user/data/models/user_api_model.dart';


// Create provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});



class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
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

      // Save to session
      await _userSessionService.saveUserSession(
        userId: user.userId!,
        email: user.email,
        username: user.username,
      );
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
      return registeredUser;
    }

    return user;
  }
  
  @override
  Future<UserApiModel?> getCurrentUser(String userId) {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
  
  @override
  Future<bool> logout(String userId) {
    // TODO: implement logout
    throw UnimplementedError();
  }
}