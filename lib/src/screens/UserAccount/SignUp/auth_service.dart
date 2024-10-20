
import 'package:fitelevate/src/screens/UserAccount/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitelevate/src/screens/UserProfileSetup/profilesetup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Home/Steps Tracker/steps_daily_track_provider.dart';
import '../../UserProfileSetup/userinfo_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Method for initializing new user
  void initializeForNewUser(BuildContext context) {
    try {
      Provider.of<UserInfoProvider>(context, listen: false).resetToDefaults();
      Provider.of<StepsDailyTrackingProvider>(context, listen: false).resetToDefaults();
      // Additional setup if necessary
    } catch (e) {
      print('Error initializing user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Initialization error: $e')));
    }
  }

  Future<void> createAccountWithPhone(
      String name,
      String email,
      String phone,
      String countryCode,
      BuildContext context,
      ) async {
    String phoneNumber = countryCode + phone;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60), // Real users will have timeout
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential = await _auth.signInWithCredential(credential);
          if (userCredential.user != null) {
            // Proceed to set up user account and navigate to the next screen
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Verification failed')));
        },
        codeSent: (String verificationId, int? resendToken) {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController otpController = TextEditingController();
              return AlertDialog(
                title: const Text('Enter OTP'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: otpController,
                      decoration: const InputDecoration(labelText: 'OTP'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: otpController.text,
                      );
                      UserCredential userCredential = await _auth.signInWithCredential(credential);
                      User? user = userCredential.user;

                      if (user != null) {
                        await _createUserAccount(
                          user.uid,
                          name,
                          email,
                          phoneNumber,
                          '',
                          '',
                          DateTime.now(),
                          DateTime.now(),
                        );
                        //Shared Preference
                        await _saveUserToPreferences(user.uid, name, email, phoneNumber);

                        Provider.of<UserAccountProvider>(context, listen: false).setUserData(
                          userId: user.uid,
                          name: name,
                          email: email,
                          phoneNumber: phoneNumber,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );
                        // Call the initializeForNewUser method here
                        initializeForNewUser(context);


                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileSetUp()),
                        );
                      }
                    },
                    child: const Text('Verify'),
                  ),
                ],
              );
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("SMS code auto retrieval timed out.");
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }


  Future<void> createAccountWithEmail(
      String name,
      String email,
      String password,
      BuildContext context,
      ) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _createUserAccount(
          user.uid,
          name,
          email,
          '',
          '',
          '',
          DateTime.now(),
          DateTime.now(),
        );
        //Shared Preference
        await _saveUserToPreferences(user.uid, name, email, '');

        Provider.of<UserAccountProvider>(context, listen: false).setUserData(
          userId: user.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        // Call the initializeForNewUser method here
        initializeForNewUser(context);


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetUp()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await _createUserAccount(
          user.uid,
          user.displayName ?? '',
          user.email ?? '',
          '',
          'Google',
          '',
          DateTime.now(),
          DateTime.now(),
        );

        //Shared Preference
        // Save user data in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.uid);
        await prefs.setString('name', user.displayName ?? '');
        await prefs.setString('email', user.email ?? '');

        Provider.of<UserAccountProvider>(context, listen: false).setUserData(
          userId: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        // Call the initializeForNewUser method here
        initializeForNewUser(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetUp()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Future<void> signInWithFacebook(BuildContext context) async {
  //   try {
  //     // Attempt Facebook login
  //     final LoginResult result = await FacebookAuth.instance.login();
  //
  //     if (result.status == LoginStatus.success) {
  //       // If login is successful, get the access token and create a credential
  //       final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
  //
  //       // Sign in with Facebook credentials
  //       UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //       User? user = userCredential.user;
  //
  //       if (user != null) {
  //         // Call your custom _createUserAccount function to store user details
  //         await _createUserAccount(
  //           user.uid,
  //           user.displayName ?? '',
  //           user.email ?? '',
  //           '',
  //           '',
  //           'Facebook',
  //           DateTime.now(),
  //           DateTime.now(),
  //         );
  //
  //         // Set user data in the provider for further use in the app
  //         Provider.of<UserAccountProvider>(context, listen: false).setUserData(
  //           userId: user.uid,
  //           name: user.displayName ?? '',
  //           email: user.email ?? '',
  //           phoneNumber: user.phoneNumber ?? '',
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         );
  //
  //         // Call the initializeForNewUser method
  //         initializeForNewUser(context);
  //
  //         // Navigate to the ProfileSetUp screen
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const ProfileSetUp()),
  //         );
  //       }
  //     } else {
  //       // If login fails, show an error message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Facebook login failed: ${result.message}')),
  //       );
  //     }
  //   } catch (e) {
  //     // Handle and display any errors that occur during the process
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  // }

  // Save user data to SharedPreferences
  Future<void> _saveUserToPreferences(String userId, String name, String email, String phoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phoneNumber', phoneNumber);
  }
  // Check user login status
  Future<void> checkUserLoginStatus(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      // User is logged in, navigate to Profile Setup or Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetUp()),
      );
    }
  }


  Future<void> _createUserAccount(
      String userId,
      String name,
      String email,
      String phoneNumber,
      String googleSignInInfo,
      String facebookSignInInfo,
      DateTime createdAt,
      DateTime updatedAt,
      ) async {
    try {
      final userDoc = _firestore.collection('user_master').doc(userId);

      await userDoc.set({
        'profile': {
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'googleInfo': googleSignInInfo,
          'createdAt': createdAt,
          'updatedAt': updatedAt,
        },
      },); // Merge data to avoid overwriting if needed

      print('User account created/updated successfully');
    } catch (e) {
      print('Error creating/updating user account: $e');
    }
  }
}
