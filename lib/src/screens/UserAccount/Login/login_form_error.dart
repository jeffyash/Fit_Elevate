import 'package:flutter/material.dart';

class LoginFormErrorProvider with ChangeNotifier {

  // Form Errors
  String? _emailError;
  String? _passwordError;
  String? _phoneError;
  bool _isValid = false;

  // Getters
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get phoneError => _phoneError;
  bool get isValid => _isValid;

  // Validate Fields
  void validateFields(
      String email,
      String password,
      String phone,
      bool isPhoneField,
      ) {
    _emailError = isPhoneField
        ? null
        : (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)
        ? 'Valid email is required'
        : null);
    _passwordError = isPhoneField
        ? null
        : (password.isEmpty || password.length < 6
        ? 'Password must be at least 6 characters'
        : null);
    _phoneError = isPhoneField && phone.isEmpty ? 'Phone number is required' : null;

    _isValid =  _emailError == null &&
        _passwordError == null &&
        _phoneError == null;
    notifyListeners();
  }
}
