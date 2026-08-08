import 'package:flutter/material.dart';

class UserSession {
  final String userId;
  final String name;
  final String mobile;
  final String email;
  final String company;

  UserSession({
    required this.userId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.company,
  });
}

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserSession? _currentSession;
  String? _pendingPhoneNumber;
  bool _isOtpSent = false;

  bool get isAuthenticated => _isAuthenticated;
  UserSession? get currentSession => _currentSession;
  String? get phoneNumber => _pendingPhoneNumber;
  bool get isOtpSent => _isOtpSent;

  String get maskedPhone {
    if (_pendingPhoneNumber == null || _pendingPhoneNumber!.length < 10) return '';
    final digits = _pendingPhoneNumber!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return _pendingPhoneNumber!;
    return '+91 ${digits.substring(0, 2)}●●●● ●●${digits.substring(8)}';
  }

  void registerUser({
    required String name,
    required String mobile,
    required String email,
    required String company,
  }) {
    final uid = 'USR_${DateTime.now().millisecondsSinceEpoch}';
    _currentSession = UserSession(
      userId: uid,
      name: name,
      mobile: mobile,
      email: email,
      company: company,
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  void sendOtp(String phone) {
    _pendingPhoneNumber = phone;
    _isOtpSent = true;
    notifyListeners();
  }

  bool verifyOtp(String otp) {
    final digits = otp.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 6) {
      _isAuthenticated = true;
      if (_currentSession == null && _pendingPhoneNumber != null) {
        _currentSession = UserSession(
          userId: 'USR_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Visitor',
          mobile: _pendingPhoneNumber!,
          email: '',
          company: '',
        );
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _currentSession = null;
    _pendingPhoneNumber = null;
    _isOtpSent = false;
    notifyListeners();
  }
}
