import 'package:fitelevate/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitelevate/src/models/food_model.dart';
import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:fitelevate/src/screens/MealTracking/FoodSearch.dart';
import '../meal_calorie_provider.dart';
import 'foodlisttile.dart';

class MealSection extends StatelessWidget {
  final String title;
  final int baseCalories;

  const MealSection({
    Key? key,
    required this.title,
    required this.baseCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MealCalorieTracker>(
      builder: (context, calorieTracker, child) {
        final foods = calorieTracker.mealFoods[title] ?? [];
        double percentage;
        switch (title) {
          case TextConstants.breakfast:
            percentage = 0.25;
            break;
          case TextConstants.lunch:
            percentage = 0.35;
            break;
          case TextConstants.dinner:
            percentage = 0.35;
            break;
          case TextConstants.snacks:
            percentage = 0.15;
            break;
          default:
            percentage = 0.25;
            break;
        }

        final allocatedCalories = (baseCalories * percentage).toInt();
        final totalCalories = foods.fold(0, (total, food) => total + food.calories);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    capitalizeFirstLetter(title),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 90),
                  Text(
                    "$totalCalories out of $allocatedCalories cal",
                    style: TextStyle(fontSize: 14),
                  ),
                  IconButton(
                    onPressed: () async {
                      final foodData = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FoodSearchPage()),
                      );

                      if (foodData != null) {
                        calorieTracker.addFood(
                          title.toLowerCase(),
                          Food(
                            name: foodData['foodName'] ?? 'Unknown Food',
                            quantity: foodData['quantity'] ?? 'Unknown Quantity',
                            calories: int.tryParse(foodData['calories'].toString()) ?? 0,
                          ),
                        );
                      }
                    },
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: ColorConstants.primaryColor,
                      child: Icon(Icons.add, color: ColorConstants.white),
                    ),
                  ),
                ],
              ),
            ),
            // Use Flexible and shrinkWrap to make the ListView expand dynamically
            foods.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true, // Ensures the ListView is embedded correctly within a Column
              physics: NeverScrollableScrollPhysics(), // Disables scrolling in ListView
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return FoodListTile(
                  foodName: food.name,
                  quantity: food.quantity,
                  calories: food.calories.toString(),
                  mealType: title.toLowerCase(), // Pass the meal type here
                  onDelete: () {
                    calorieTracker.deleteFood(title.toLowerCase(), food); // Use title as mealType here
                  },
                );
              },
            )
                : Text("No items added yet.", style: TextStyle(fontSize: 16)),
          ],
        );
      },
    );
  }
}
