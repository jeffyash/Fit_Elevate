import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileInfoProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userId;
  String _userName = '';
  String _email = '';
  String _phoneNumber = '';
  String _gender = '';
  int _heightCm = 0;
  double _weightKg = 0.0;
  int _age = 0;
  String _goal = '';
  String _calorieGoal = '';
  double _targetWeightKg = 0.0;
  List<String> _dietPreferences = [];
  File? _imageFile;
  String? _uploadedImageUrl;



  String get userName => _userName;

  String get email => _email;

  String get phoneNumber => _phoneNumber;

  String get gender => _gender;

  int get heightCm => _heightCm;

  double get weightKg => _weightKg;

  double get targetWeightKg => _targetWeightKg;

  int get age => _age;

  String get goal => _goal;

  String get calorieGoal => _calorieGoal;

  List<String> get dietPreferences => _dietPreferences;

  File? get imageFile => _imageFile;

  String? get uploadedImageUrl => _uploadedImageUrl;

  final ImagePicker _picker = ImagePicker();

  void setUploadedImageUrl(String? imageUrl) {
    _uploadedImageUrl = imageUrl;
    notifyListeners();
  }

  void _getUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    } else {
      print('No user is currently signed in.');
    }
  }

  // Constructor to initialize step tracking
  ProfileInfoProvider() {
   fetchUserInfo();
  }

  // Ensure _userId is set before making updates
  Future<void> initialize() async {
    _getUserId();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      if (_userId != null) {
        DocumentSnapshot userDoc = await _firestore.collection('user_master')
            .doc(_userId!)
            .get();
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            var profile = data['profile'] as Map<String, dynamic>? ?? {};
            var physicalAttributes = data['physicalAttributes'] as Map<String, dynamic>? ?? {};

            _userName = profile['name'] ?? '';
            _email = profile['email'] ?? '';
            _phoneNumber=profile['phoneNumber']??"";
            _gender = (physicalAttributes['gender'] ?? '');
            _heightCm = (physicalAttributes['heightCm'] as num).toInt();
            _weightKg = (physicalAttributes['weightKg'] as num).toDouble();
            _targetWeightKg = (physicalAttributes['targetWeightKg'] as num).toDouble();
            _age = (physicalAttributes['age'] as num).toInt();
            _goal = physicalAttributes['goal'] ?? '';
            _calorieGoal = physicalAttributes['selectedCalorieGoal'] ?? '';

            // Fetch and assign the profile image URL
            _uploadedImageUrl = data['profileImageUrl'];

            // Logging for debugging purposes
            print('Fetched User Info: Name: $_userName, Email: $_email, PhoneNumber :$_phoneNumber, Height: $_heightCm, Weight: $_weightKg, Goal: $_goal, CalorieGoal: $_calorieGoal, Profile Picture: $_uploadedImageUrl');
          }
        }
      } else {
        print('No user ID available for fetching user info.');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
    notifyListeners();
  }


  Future<void> updateBasicInfo({
    required String userName,
    required String email,
    required String phoneNumber,
    required String gender,
    required int heightCm,
    required double weightKg,
    required double targetWeightKg,
    required int age,
    required String calorieGoal,
  }) async {
    try {
      if (_userId != null) {
        await _firestore.collection('user_master').doc(_userId!).update({
          'profile.name': userName,
          'profile.email': email,
          'profile.phoneNumber': phoneNumber,
          'physicalAttributes.gender': gender,
          'physicalAttributes.age': age,
          'physicalAttributes.heightCm': heightCm,
          'physicalAttributes.weightKg': weightKg,
          'physicalAttributes.targetWeightKg': targetWeightKg,
          'physicalAttributes.selectedCalorieGoal': calorieGoal,
        });
        print('Basic Info updated');
      } else {
        print('No user ID available for updating basic info.');
      }
    } catch (e) {
      print('Failed to update basic info: $e');
    }
    notifyListeners();
  }

  Future<void> updateDietPreferences(List<String> newPreferences) async {
    _dietPreferences = newPreferences;
    notifyListeners();

    // Update Firestore
    try {
      if (_userId != null) {
        await _firestore.collection('user_master').doc(_userId!).update({
          'physicalAttributes.dietPreferences': newPreferences,
        });
        print('Diet Preferences updated');
      } else {
        print('No user ID available for updating diet preferences.');
      }
    } catch (e) {
      print("Error updating Firestore: $e");
    }
  }

  // Method to pick image from the gallery
  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Image path: ${image.path}");  // Check the path type here
      _imageFile = File(image.path);       // This should work if path is a String
      await uploadProfilePicture();  // Upload the image after picking
      notifyListeners();
      return _imageFile;
    }
    return null;
  }


  // Method to upload the file to Firebase Storage
  Future<bool> uploadFile(File file) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('Photos/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get download URL of uploaded file
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      _uploadedImageUrl = downloadUrl;

      print("File Uploaded to: $downloadUrl");
      notifyListeners();  // Notify that file upload is completed
      return true;
    } catch (e) {
      print("Error uploading file: $e");
      return false;
    }
  }

  Future<void> uploadProfilePicture() async {
    if (_imageFile == null || _userId == null) return;

    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('profilePictures/$_userId.jpg');

      // Upload the file to Firebase Storage
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL of the uploaded file
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new profile picture URL
      await FirebaseFirestore.instance.collection('user_master').doc(_userId!).update({
        'profileImageUrl': downloadUrl,
      });

      // Set the uploaded image URL in the provider
      _uploadedImageUrl = downloadUrl;

      print('Profile picture uploaded and URL saved: $downloadUrl');
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Ensure user ID is available
      if (_userId == null) {
        print('No user ID available for account deletion.');
        return;
      }

      // Delete user document from Firestore
      await _firestore.collection('user_master').doc(_userId!).delete();

      // Get the user associated with the userId (if needed)
      User? user = _auth.currentUser; // Get the currently signed-in user

      // Only delete from Firebase Auth if this is the current user
      if (user != null && user.uid == _userId) {
        await user.delete(); // Delete the user from Firebase Auth
      }

      print('Account deleted successfully');
    } catch (e) {
      print('Error deleting account: $e');
      // Optionally, you could throw an exception or return an error message
      // throw Exception('Failed to delete account: $e');
    }
  }



}