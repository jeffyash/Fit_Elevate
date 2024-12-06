import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../constants/dietData_constants.dart';
import '../../constants/text_constants.dart';
import '../../models/diet_data.dart';
import 'DietFoodItems.dart';

class DietPlanDetailPage extends StatelessWidget {
  final DietPlanData dietPlan;
  final String userGoal;

  const DietPlanDetailPage({Key? key, required this.dietPlan, required this.userGoal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Select the correct diet plan details based on the user's goal
    final List<DietPlanDetails> selectedDietPlans = userGoal == TextConstants.weightGain
        ? DataConstants.weightGainDietPlan
        : userGoal == TextConstants.weightLoss
        ? DataConstants.weightLossDietPlan
        : userGoal == TextConstants.maintainWeight
        ? DataConstants.weightMaintenanceDietPlan
        : userGoal == TextConstants.muscleGain
        ? DataConstants.muscleGainDietPlan
        : []; // Handle case where goal doesn't match any known category


    // Find the corresponding diet plan details
    final DietPlanDetails dietPlanDetails = selectedDietPlans.firstWhere(
          (details) => details.title.toLowerCase().contains(dietPlan.title.toLowerCase()),
      orElse: () => DietPlanDetails(
        title: 'No details available',
        description: 'No details available',
        foodsToInclude: 'N/A',
        foodsToAvoid: 'N/A',
        dietGoal: 'N/A',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
        ),
        toolbarHeight: 35,
      ),
      body: Stack(
        children: [
          // Image Container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.3, // Adjust the height of the image
              child: Image.asset(
                dietPlan.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenHeight / 13, // Adjusted to start below the image
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(top: screenHeight * 0.2), // Margin to avoid overlapping with the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        dietPlanDetails.title,
                        style: TextStyle(
                          fontSize: 24,
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      dietPlanDetails.description,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Foods to Include:',
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      dietPlanDetails.foodsToInclude,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Foods to Avoid:',
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorConstants.cardColor1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dietPlanDetails.foodsToAvoid,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Goal:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dietPlanDetails.dietGoal,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(ColorConstants.primaryColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DietFoodItems(dietPlanTitle: dietPlan.title),
                            ),
                          );
                        },
                        child: Text(
                          "View Meals",
                          style: TextStyle(
                            color: ColorConstants.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ColorConstants.white,
    );
  }
}
