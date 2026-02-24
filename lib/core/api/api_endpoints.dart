import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.1';
  static const int _port = 8080;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  // Base URL - change this for production
  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => serverUrl;
  static String get mediaServerUrl => serverUrl;
  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ User Endpoints ============
  static const String userLogin = '/auth/login';
  static const String userRegister = '/auth/register';
  static const String updateProfile = '/auth/update';
  static const String updateUserByEmail = '/auth/update-by-email';
  static const String getUser = '/auth/users';

  // ============ Address Endpoints ============
  static const String address = '/address';
}
