import 'package:fitelevate/src/screens/HomePage/homepage.dart';
import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../models/nutritional_calc.dart';
import 'Widgets/nutritionalpiechart.dart';

class NutritionGoals extends StatelessWidget {
  final double dailyCalorieIntake;
  final int age;
  final String gender;
  final double proteinGrams;
  final double fatGrams;
  final double carbGrams;
  final List<String> dietPreferences;

  const NutritionGoals({
    super.key,
    required this.dailyCalorieIntake,
    required this.age,
    required this.gender,
    required this.proteinGrams,
    required this.fatGrams,
    required this.carbGrams,
    required this.dietPreferences,
  });

  @override
  Widget build(BuildContext context) {

    final lowCarb = dietPreferences.contains('Low Carb');// Check if the user has selected low carb diet

    // Use NutritionCalculations to get nutrient values
    final nutrients = NutritionCalculations.calculateNutrients(dailyCalorieIntake,lowCarb: lowCarb );
    final proteinGrams = nutrients['proteinGrams']!;
    final fatGrams = nutrients['fatGrams']!;
    final carbGrams = nutrients['carbGrams']!;
    final proteinPercentage = nutrients['proteinPercentage']!;
    final fatPercentage = nutrients['fatPercentage']!;
    final carbPercentage = nutrients['carbPercentage']!;

    // Convert daily calorie intake to integer
    final dailyCalorieIntakeInt = NutritionCalculations.convertDailyCalorieToInt(dailyCalorieIntake);

    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Daily Nutrition Goals',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20),
            NutritionChart(
              carbsGrams: carbGrams,
              proteinGrams: proteinGrams,
              fatsGrams: fatGrams,
            ),
            const  SizedBox(height: 20),

            Text(
              'Energy: $dailyCalorieIntakeInt kcal',
              style:  const TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20),
            Text(
              'Proteins: ${(proteinPercentage * 100).toStringAsFixed(0)}% (${proteinGrams.toInt()}g)',
              style:  const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Fats: ${(fatPercentage * 100).toStringAsFixed(0)}% (${fatGrams.toInt()} g)',
              style:  const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Carbohydrates: ${(carbPercentage * 100).toStringAsFixed(0)}% (${carbGrams.toInt()} g)',
              style:  const TextStyle(fontSize: 18),
            ),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorConstants.primaryColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                padding: MaterialStateProperty.all( const EdgeInsets.symmetric(horizontal: 75, vertical: 15)),
              ),
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false, // This will remove all previous routes
                );

              },
              child:  const Text(
                "Go to Home",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
