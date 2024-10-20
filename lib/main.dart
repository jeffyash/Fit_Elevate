import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:fitelevate/src/screens/UserAccount/Login/login_form_error.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:fitelevate/src/screens/Onboard/onboard_screen.dart';
import 'package:fitelevate/src/screens/Home/WeightTracker/weight_data_provider.dart';
import 'package:fitelevate/src/screens/HomePage/homepage_provider.dart';
import 'package:fitelevate/src/screens/More/profile_info_provider.dart';
import 'package:fitelevate/src/screens/UserProfileSetup/userinfo_provider.dart';
import 'src/screens/Home/Calories Burned Tracker/CaloriesBurnedProvider.dart';
import 'src/screens/Home/Steps Tracker/steps_daily_track_provider.dart';
import 'src/screens/Home/Water Tracker/water_tracking_provider.dart';
import 'src/screens/MealTracking/meal_calorie_provider.dart';
import 'src/screens/UserAccount/Login/login_provider.dart';
import 'src/screens/UserAccount/SignUp/form_error_provider.dart';
import 'src/screens/UserAccount/user_account_provider.dart';


CollectionReference users = FirebaseFirestore.instance.collection('user_master');

Future<List<Map<String, dynamic>>> getUserData() async {
  try {
    print("Inside getUserData function...");
    QuerySnapshot snapshot = await users.get();
    List<Map<String, dynamic>> userData = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    print("User data retrieved successfully.");
    return userData;
  } catch (e) {
    print("Error retrieving user data: $e");
    return []; // Return an empty list in case of error
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // Loads environment variables from the .env file

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId:dotenv.env['FIREBASE_APP_ID']??'',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']??'',
        projectId:dotenv.env['FIREBASE_PROJECT_ID']??'',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']??'',
      ),
    );

    //  App Check with Play Integrity provider for Android
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );

  runApp(FitElevateApp ());
  } catch(error){
    print("Error loading .env file: $error");
    print("Error initializing Firebase:$error");
  }
}

class FitElevateApp extends StatelessWidget {

  const FitElevateApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserAccountProvider()),
          ChangeNotifierProvider(create: (context) => FormErrorProvider()),
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => LoginFormErrorProvider()),
          ChangeNotifierProvider(create: (context) => UserInfoProvider()),
          ChangeNotifierProvider(create: (_) => ProfileInfoProvider()),
          ChangeNotifierProvider(create: (_) => HomePageProvider()),
          ChangeNotifierProvider(create: (_) => WaterIntakeProvider()),
          ChangeNotifierProvider(create: (_) => WeightTrackerProvider()),
          ChangeNotifierProvider(create: (_) => StepsDailyTrackingProvider()),
          ChangeNotifierProvider(create: (_) => MealCalorieTracker()),
          ChangeNotifierProvider(create: (_) => CaloriesBurnedProvider()),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fit Elevate',
        theme: ThemeData(
          primarySwatch: Colors.blue,

        ),
              home: OnboardPage(),
      ),
    );
  }
}

