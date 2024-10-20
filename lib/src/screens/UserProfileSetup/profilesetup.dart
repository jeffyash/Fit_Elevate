import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/constants/path_constants.dart';
import 'package:fitelevate/src/screens/UserProfileSetup/userinfo_provider.dart';
import 'package:fitelevate/src/screens/UserAccount/user_account_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/text_constants.dart';
import '../../models/nutritional_calc.dart';
import 'nutrition_goal.dart';
import 'age_screen.dart';
import 'daily_calorie.dart';
import 'diet_preference.dart';
import 'goal_setting.dart';
import 'height_screen.dart';
import 'physical_activity.dart';
import 'target_weight.dart';
import 'weight_screen.dart';
import 'gender_screen.dart';

class ProfileSetUp extends StatelessWidget {
  const ProfileSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                      image: AssetImage(PathConstants.muscle),
                      height: 70,
                      width: 60),
                  Image(
                      image: AssetImage(PathConstants.fitnessWatch),
                      height: 70,
                      width: 60),
                  Image(
                      image: AssetImage(PathConstants.waterBottle),
                      height: 70,
                      width: 60),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                      image: AssetImage(PathConstants.heartBeat),
                      height: 70,
                      width: 60),
                  Image(
                      image: AssetImage(PathConstants.yoga),
                      height: 70,
                      width: 60),
                ],
              ),
              SizedBox(height: 30),
              Text(
                TextConstants.fitelevate,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Text(
                TextConstants.readytogo,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                TextConstants.readytogo_desc,
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: screenWidth,
        height: screenHeight / 9,
        decoration: BoxDecoration(
            color: ColorConstants.primaryColor,
            borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserInformation()),
                    );
                  },
                  child: const Text(
                    TextConstants.letsdoit,
                    style: TextStyle(),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> _pages = [
    GenderScreen(),
    AgeScreen(),
    HeightScreen(),
    WeightScreen(),
    DietPreference(),
    ActivityLevel(),
    GoalSetting(),
    TargetWeight(),
    DailyCalorie(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final userAccountProvider = Provider.of<UserAccountProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: _pages,
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length, // Number of pages
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: _currentPage == index
                          ? ColorConstants.primaryColor
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          color: ColorConstants.primaryColor, // Replace with your primary color
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage >=
                  0) // Show "Previous" button only if not on the first page
                GestureDetector(
                  onTap: () {
                    if (_currentPage == 0) {
                      Navigator.pop(context); // Go to ProfileSetUp screen
                    } else {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Text(
                    "<< Previous",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              const SizedBox(
                width: 125,
              ),
              // Show "Continue" or "Finish" button based on the current page
              ElevatedButton(
                onPressed: () async {
                  if (_currentPage == _pages.length - 1) {
                    final dailyCalorieIntake =
                        userInfo.calculateDailyCalorieGoal(
                            userInfo.selectedCalorieGoal);
                    final age = userInfo.age; // Directly from userFitness
                    final gender = userInfo.gender; // Directly from userFitness
                    final dietPreferences = userInfo.dietPreferences;

                    // Calculate nutrient values
                    final nutrients = NutritionCalculations.calculateNutrients(
                        dailyCalorieIntake);
                    final carbsGrams = nutrients['carbGrams']!;
                    final proteinGrams = nutrients['proteinGrams']!;
                    final fatsGrams = nutrients['fatGrams']!;

                    // Save the data to Firestore
                    final userDoc = FirebaseFirestore.instance
                        .collection('user_master')
                        .doc(userAccountProvider.userId);

                    await userDoc.update({
                      'physicalAttributes': userInfo.userFitness.toMap(),
                    });

                    // Navigate to home screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NutritionGoals(
                                dailyCalorieIntake: dailyCalorieIntake,
                                age: age,
                                gender: gender,
                                dietPreferences: dietPreferences,
                                carbGrams: carbsGrams,
                                proteinGrams: proteinGrams,
                                fatGrams: fatsGrams,
                              ),),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(
                  _currentPage == _pages.length - 1 ? "Finish" : "Continue >>",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
