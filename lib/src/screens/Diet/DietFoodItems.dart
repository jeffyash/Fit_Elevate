import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:fitelevate/src/models/diet_data.dart';
import 'package:fitelevate/utils/date_utils.dart';
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/dietData_constants.dart';
import '../../constants/plan_text.dart';

class DietFoodItems extends StatelessWidget {
  final String dietPlanTitle;

  const DietFoodItems({Key? key, required this.dietPlanTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the food items based on the diet plan title
    List<FoodItems> breakfastItems = [];
    List<FoodItems> lunchItems = [];
    List<FoodItems> dinnerItems = [];
    List<FoodItems> snackItems = [];

    if (dietPlanTitle.contains(PlansTextConstants.lowCarbDietTitle)) {
      breakfastItems = FoodData.lowcarb_breakfast;
      lunchItems = FoodData.lowcarb_lunch;
      dinnerItems = FoodData.lowcarb_dinner;
      snackItems = FoodData.lowcarb_snacks;
    } else if (dietPlanTitle.contains(PlansTextConstants.mediterraneanDietTitle)) {
      breakfastItems = FoodData.mediterranean_breakfast;
      lunchItems = FoodData.mediterranean_lunch;
      dinnerItems = FoodData.mediterranean_dinner;
      snackItems = FoodData.mediterranean_snacks;
    }else if (dietPlanTitle.contains(PlansTextConstants.intermittentFastingTitle)) {
      breakfastItems = FoodData.intermittent_breakfast;
      lunchItems = FoodData.intermittent_lunch;
      dinnerItems = FoodData.intermittent_dinner;
      snackItems = FoodData.intermittent_snacks;
    }else if (dietPlanTitle.contains(PlansTextConstants.veganDietTitle)) {
      breakfastItems = FoodData.vegan_breakfast;
      lunchItems = FoodData.vegan_lunch;
      dinnerItems = FoodData.vegan_dinner;
      snackItems = FoodData.vegan_snacks;
    }
     else if (dietPlanTitle.contains(PlansTextConstants.highCalorieDietTitle)) {
      breakfastItems = FoodData.highcalorie_breakfast;
      lunchItems = FoodData.highcalorie_lunch;
      dinnerItems = FoodData.highcalorie_dinner;
      snackItems = FoodData.highcalorie_snacks;
    }
    else if (dietPlanTitle.contains(PlansTextConstants.highProteinDietTitle)) {
      breakfastItems = FoodData.highProtein_breakfast;
      lunchItems = FoodData.highProtein_lunch;
      dinnerItems = FoodData.highProtein_dinner;
      snackItems = FoodData.highProtein_snacks;
    }
    else if (dietPlanTitle.contains(PlansTextConstants.balancedDietWithHealthyFatsTitle)) {
      breakfastItems = FoodData.balancedDiet_breakfast;
      lunchItems = FoodData.balancedDiet_lunch;
      dinnerItems = FoodData.balancedDiet_dinner;
      snackItems = FoodData.balancedDiet_snacks;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dietPlanTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breakfast Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
               capitalizeFirstLetter(TextConstants.breakfast) ,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            buildFoodItemsList(breakfastItems),

            // Lunch Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                capitalizeFirstLetter(TextConstants.lunch),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            buildFoodItemsList(lunchItems),

            // Dinner Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                capitalizeFirstLetter(TextConstants.dinner),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            buildFoodItemsList(dinnerItems),

            // Snacks Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                capitalizeFirstLetter(TextConstants.snacks),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            buildFoodItemsList(snackItems),
          ],
        ),
      ),
      );
  }

  // Function to build a ListView for displaying food items
  Widget buildFoodItemsList(List<FoodItems> foodItems) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = foodItems[index];
          return Container(
            width: 220, // Increase card width for more space
            height: 400,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              color: ColorConstants.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    width: 220, // Increase image width to match card width
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: foodItem.foodImage.startsWith('http')
                              ? NetworkImage(foodItem.foodImage) // Network image
                              : AssetImage(foodItem.foodImage) as ImageProvider, // Asset image
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodItem.foodTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                            maxLines: 2, // Limit text to two lines
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
