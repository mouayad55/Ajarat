import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_urls.dart';
import '../models/user_model.dart'; // Import User Model

class AuthProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  
  bool _isLoading = false;
  String? _token;
  UserModel? _currentUser; // Store User Data

  bool get isLoading => _isLoading;
  String? get token => _token;
  UserModel? get currentUser => _currentUser;

  // 1. Check Auto Login
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('auth_token')) return false;

    _token = prefs.getString('auth_token');
    
    // Load User Data from Storage
    if (prefs.containsKey('user_data')) {
      final userData = jsonDecode(prefs.getString('user_data')!);
      _currentUser = UserModel.fromJson(userData);
    }

    notifyListeners();
    return true;
  }

  // 2. Login
  Future<void> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.post(AppUrls.login, {
        'phone': phone,
        'password': password,
      });

      // Save Token
      _token = response['token'];
      
      // Save User Data
      if (response['user'] != null) {
        _currentUser = UserModel.fromJson(response['user']);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      
      if (_currentUser != null) {
        await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
      }

    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. Register
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String birthDate,
    required File personalPhoto,
    required File idPhoto,
    String role = 'user',
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiClient.postMultipart(
        AppUrls.register,
        {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'birth_date': birthDate,
          'role': role,
        },
        {
          'personal_photo': personalPhoto,
          'id_photo': idPhoto,
        },
      );
      // Registration successful, user must login now.
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(AppUrls.logout, {});
    } catch (_) {}

    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}