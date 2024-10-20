import 'package:flutter/material.dart';

class FormErrorProvider with ChangeNotifier {

  // Form Errors
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _phoneError;
  bool _isObscured = true;
  bool _isValid = false;

  // Getters
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get phoneError => _phoneError;
  bool get isObscured => _isObscured;
  bool get isValid => _isValid;

  // Validate Fields
  void validateFields(
      String name,
      String email,
      String password,
      String phone,
      bool isPhoneField,
      ) {
    _nameError = name.isEmpty ? 'Name is required' : null;
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

    _isValid = _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _phoneError == null;
    notifyListeners();
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    _isObscured = !_isObscured;
    notifyListeners();
  }
}
