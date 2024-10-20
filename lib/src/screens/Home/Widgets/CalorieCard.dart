import 'package:fitelevate/src/screens/MealTracking/meal_calorie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/text_constants.dart';
import '../../UserProfileSetup/userinfo_provider.dart';

class CaloriesCard extends StatelessWidget {

  const CaloriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final userInfo = Provider.of<UserInfoProvider>(context);
    final baseCalories = userInfo.calculateDailyCalorieGoal(userInfo.selectedCalorieGoal).toInt();//Convert to int
    final mealInfo=Provider.of<MealCalorieTracker>(context);
    final foodCalories = mealInfo.getTotalCaloriesForAllMeals().toInt();
    final remainingCalories=baseCalories-foodCalories;
    final progress = (foodCalories / baseCalories).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(TextConstants.calories, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                   SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 40,
                          left: 30,
                          child: Column(
                            children: [
                              Text("$remainingCalories", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const  Text(TextConstants.remaining),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade300,
                              valueColor:  AlwaysStoppedAnimation<Color>(ColorConstants.primaryColor),
                              strokeWidth: 7,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 55),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildInfoRow(Icons.flag, 'Base Goal', '$baseCalories calories', Colors.grey),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.restaurant, 'Food', '$foodCalories calories', Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInfoRow(IconData icon, String title, String subtitle, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            Text(subtitle, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ],
    );
  }
}
