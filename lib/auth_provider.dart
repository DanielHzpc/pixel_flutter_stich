import 'package:flutter/material.dart';
import 'auth_service.dart';

enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.idle;
  String? _error;

  AuthStatus get status => _status;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      _status = AuthStatus.success;
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
    }

    notifyListeners();
  }
}