import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitelevate/src/screens/HomePage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_fitness_model.dart';


class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isObscured = true;
  String? _errorMessage;

  // Getter for properties
  bool get isObscured => _isObscured;
  String? get errorMessage => _errorMessage;

  // Toggles password visibility
  void togglePasswordVisibility() {
    _isObscured = !_isObscured;
    notifyListeners();
  }

  // Sets an error message
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Fetches user data from Firestore and updates UserAccountProvider and UserInfoProvider
  Future<void> fetchUserData(BuildContext context) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        // Fetch user document from 'user_master' collection
        final userDoc = await FirebaseFirestore.instance.collection('user_master').doc(userId).get();

        if (userDoc.exists) {
          final fitnessData = userDoc.data()?['physicalAttributes'];

          if (fitnessData != null) {


            // Ensure that data types are handled properly
            String gender = fitnessData['gender'] ?? '';
            int age = fitnessData['age'] is int
                ? fitnessData['age']
                : (fitnessData['age'] as double).toInt();
            double weightKg = fitnessData['weightKg'] is double
                ? fitnessData['weightKg']
                : (fitnessData['weightKg'] as int).toDouble();

            double weightLbs = fitnessData['weightLbs'] is double
                ? fitnessData['weightLbs']
                : (fitnessData['weightLbs'] as int).toDouble();

            int heightCm = fitnessData['heightCm'] is int
                ? fitnessData['heightCm']
                : (fitnessData['heightCm'] as double).toInt();

            int heightFt = fitnessData['heightFt'] is int
                ? fitnessData['heightFt']
                : (fitnessData['heightFt'] as double).toInt();

            int heightInch = fitnessData['heightInch'] is int
                ? fitnessData['heightInch']
                : (fitnessData['heightInch'] as double).toInt();

            List<String> dietPreferences = List<String>.from(fitnessData['dietPreferences'] ?? []);

            String activityLevel = fitnessData['activityLevel'] ?? '';

            String goal = fitnessData['goal'] ?? '';

            double targetWeightKg = fitnessData['targetWeightKg'] is double
                ? fitnessData['targetWeightKg']
                : (fitnessData['targetWeightKg'] as int).toDouble();

            double targetWeightLbs = fitnessData['targetWeightLbs'] is double
                ? fitnessData['targetWeightLbs']
                : (fitnessData['targetWeightLbs'] as int).toDouble();

            String selectedCalorieGoal = fitnessData['selectedCalorieGoal'] ?? '';

            // Create an instance of UserFitnessProfile
            UserFitnessProfile userProfile = UserFitnessProfile(
              gender: gender,
              age: age,
              weightKg: weightKg,
              weightLbs: weightLbs,
              heightCm: heightCm,
              heightFt: heightFt,
              heightInch: heightInch,
              dietPreferences: dietPreferences,
              activityLevel: activityLevel,
              goal: goal,
              targetWeightKg: targetWeightKg,
              targetWeightLbs: targetWeightLbs,
              selectedCalorieGoal: selectedCalorieGoal,
            );

            // Now you can use the userProfile instance as needed
            print('UserProfile instance created successfully: $userProfile');
            // For example, you can update a provider or display the data
          } else {
            // Handle the case where fitnessData is null
            print('Fitness data is not available.');
          }
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('User not authenticated.');
    }
  }

  // Logs in with email and password
  Future<void> login(String email, String password, BuildContext context) async {
    setErrorMessage(null); // Clear any existing error messages.

    // Validate email and password inputs.
    if (email.isEmpty && password.isEmpty) {
      setErrorMessage('Please enter both email and password.');
      return;
    } else if (email.isEmpty) {
      setErrorMessage('Please enter your email.');
      return;
    } else if (password.isEmpty) {
      setErrorMessage('Please enter your password.');
      return;
    }

    try {
      // Attempt to sign in with email and password.
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If login is successful, navigate to the home page.
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Handle specific error codes from FirebaseAuth.
        switch (e.code) {
          case 'user-not-found':
            setErrorMessage('Invalid email. User not found.');
            break;
          case 'wrong-password':
            setErrorMessage('Invalid password. Please try again.');
            break;
          case 'too-many-requests':
            setErrorMessage('Too many login attempts. Please try again later.');
            break;
          default:
            setErrorMessage('An error occurred. Please try again.');
        }
      } else {
        setErrorMessage('An unexpected error occurred. Please try again.');
      }
    }
  }


  // Signs in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Store the login status
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Set logged-in status
        // Fetch user data after successful login
        await fetchUserData(context);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false, // This clears all previous routes
        );
      }
    } catch (e) {
      setErrorMessage('Failed to sign in with Google. Please try again.');
    }
  }

  Future<void> signInWithPhone(
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

            // Fetch user data after successful login
            await fetchUserData(context);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false, // This clears all previous routes
            );
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
                      if (userCredential.user != null) {
                        // Save user data, and navigate to Profile Setup screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>  HomePage()),
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

}


