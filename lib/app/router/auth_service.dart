import 'package:flutter/material.dart';
import 'package:festeasy/features/auth/domain/entities/user.dart';

/// A mock authentication service to simulate user login state.
///
/// In a real app, this would be a more robust service that communicates
/// with a backend, checks for tokens, etc. For this migration, it simply
/// holds a boolean flag and notifies listeners when it changes.
class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  User? _currentUser;

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _isAuthenticated;

  /// The currently logged in user.
  User? get currentUser => _currentUser;

  /// The role of the current user (client or provider).
  String? get userRole => _currentUser?.role;

  /// Logs the user in with user data.
  void loginWithUser(User user) {
    _isAuthenticated = true;
    _currentUser = user;
    notifyListeners();
  }

  /// Logs the user in (legacy method for compatibility).
  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Logs the user out.
  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
