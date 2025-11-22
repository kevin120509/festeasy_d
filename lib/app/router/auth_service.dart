import 'package:flutter/material.dart';

/// A mock authentication service to simulate user login state.
///
/// In a real app, this would be a more robust service that communicates
/// with a backend, checks for tokens, etc. For this migration, it simply
/// holds a boolean flag and notifies listeners when it changes.
class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _isAuthenticated;

  /// Logs the user in.
  ///
  /// This is called from the LoginCubit upon successful authentication.
  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Logs the user out.
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
