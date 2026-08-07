import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _phoneNumber;
  bool _isOtpSent = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get phoneNumber => _phoneNumber;
  bool get isOtpSent => _isOtpSent;

  String get maskedPhone {
    if (_phoneNumber == null || _phoneNumber!.length < 10) return '';
    final digits = _phoneNumber!.replaceAll(RegExp(r'\D'), '');
    return '+91 ${digits.substring(0, 2)}●●●● ●●${digits.substring(8)}';
  }

  /// Mock: always succeeds — stores the phone and marks OTP as sent.
  void sendOtp(String phone) {
    _phoneNumber = phone;
    _isOtpSent = true;
    notifyListeners();
  }

  /// Mock: accepts any 6-digit numeric code.
  bool verifyOtp(String otp) {
    final digits = otp.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 6) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _phoneNumber = null;
    _isOtpSent = false;
    notifyListeners();
  }
}
