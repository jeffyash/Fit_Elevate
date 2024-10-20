import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';

class UserAccountProvider with ChangeNotifier {
  String? _userId;
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String? _password;
  String? _googleSignInInfo;
  String? _profileImageUrl;
  DateTime _createdAt = DateTime.now();
  DateTime _updatedAt = DateTime.now();

  // Getters
  String? get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String? get password => _password;
  String? get googleSignInInfo => _googleSignInInfo;
  String? get profileImageUrl => _profileImageUrl;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;

  // Set User Data
  void setUserData({
    required String userId,
    required String name,
    required String email,
    String? phoneNumber,
    String? password,
    String? googleSignInInfo,
    String? profileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    _userId = userId;
    _name = name;
    _email = email;
    _phoneNumber = phoneNumber ?? '';
    _password = password;
    _googleSignInInfo = googleSignInInfo;
    _profileImageUrl = profileImageUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    notifyListeners();
  }

  // Methods to get UserCreation
  UserProfile get userProfile {
    return UserProfile(
      userId: _userId!,
      name: _name,
      email: _email,
      phoneNumber: _phoneNumber,
      googleSignInInfo: _googleSignInInfo,
      profileImageUrl: _profileImageUrl,
      createdAt: _createdAt,
      updatedAt: _updatedAt,
    );
  }
}
