import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? get currentUser => _authRepository.currentUser;
  bool get isAuthenticated => _authRepository.currentUser != null;
  bool get isAdmin => _authRepository.currentUser?.isAdmin ?? false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.login(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String address = '',
    String role = 'customer',
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        role: role,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    notifyListeners();
  }

  Future<bool> sendForgotPasswordEmail(String email) async {
    _setLoading(true);
    try {
      await _authRepository.sendForgotPasswordEmail(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    await _authRepository.updateUserProfile(updatedUser);
    notifyListeners();
  }
}
