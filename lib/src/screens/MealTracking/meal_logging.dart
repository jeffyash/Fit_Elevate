import 'package:fitelevate/src/screens/MealTracking/Widget/meal_calendar_widget.dart';
import 'package:fitelevate/src/screens/MealTracking/meal_calorie_provider.dart';
import 'package:flutter/material.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:provider/provider.dart';
import '../UserProfileSetup/userinfo_provider.dart';
import 'Widget/meal_section.dart';

class MealTrackerPage extends StatefulWidget {
  @override
  State<MealTrackerPage> createState() => _MealTrackerPageState();
}

class _MealTrackerPageState extends State<MealTrackerPage> {
  bool _isCalendarVisible = false;

  @override
  void initState() {
    super.initState();
    // Schedule the update after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
     // _loadMeals(); // Update the state after the build
    });
  }

  // Future<void> _loadMeals() async {
  //   final mealTracker = Provider.of<MealCalorieTracker>(context, listen: false);
  //
  //   // Access the selected date from the provider
  //   DateTime selectedDate = mealTracker.selectedDate;
  //
  //   // Update the tracker with the selected date
  //   mealTracker.updateSelectedDate(selectedDate);
  // }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final mealTracker = Provider.of<MealCalorieTracker>(context);
    final baseCalories = userInfo.calculateDailyCalorieGoal(userInfo.selectedCalorieGoal).toInt();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            setState(() {
              _isCalendarVisible = !_isCalendarVisible;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mealTracker.getDateTitle(),
                style: const TextStyle(fontSize: 20),
              ),
              Icon(
                _isCalendarVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 24,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              MealSection(title: TextConstants.breakfast, baseCalories: baseCalories),
              MealSection(title: TextConstants.lunch, baseCalories: baseCalories),
              MealSection(title: TextConstants.dinner, baseCalories: baseCalories),
              MealSection(title: TextConstants.snacks, baseCalories: baseCalories),
            ],
          ),
          if (_isCalendarVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isCalendarVisible = false;
                  });
                  // _loadMeals();
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          if (_isCalendarVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.white,
                child: MealCalendarWidget(),
              ),
            ),
        ],
      ),
    );
  }
}
