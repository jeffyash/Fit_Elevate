import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/constants/path_constants.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'userinfo_provider.dart'; // Update with the correct path

class GoalSetting extends StatelessWidget {
  const GoalSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                TextConstants.goal,
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  TextConstants.specificGoal,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGoalCard(
                          'Weight Loss', TextConstants.weightLoss, userData),
                      const SizedBox(width: 20),
                      _buildGoalCard(
                          'Weight Gain', TextConstants.weightGain, userData),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGoalCard('Maintain Weight',
                          TextConstants.maintainWeight, userData),
                      const SizedBox(width: 20),
                      _buildGoalCard(
                          'Gain Muscle', TextConstants.muscleGain, userData),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(String goal, String title, UserInfoProvider userData) {
    final isSelected = userData.goal == goal;

    return GestureDetector(
      onTap: () {
        userData.goal = goal; // Update goal in provider
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Card(
          color: isSelected ? ColorConstants.primaryColor : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(_getGoalIconPath(goal)),
                width: 55,
                height: 55,
                color: isSelected ? Colors.white : ColorConstants.primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: isSelected ? Colors.white : ColorConstants.textBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGoalIconPath(String goal) {
    switch (goal) {
      case TextConstants.weightLoss:
        return PathConstants.weightLoss;
      case TextConstants.weightGain:
        return PathConstants.weightGain;
      case TextConstants.maintainWeight:
        return PathConstants.maintainWeight;
      case TextConstants.muscleGain:
        return PathConstants.muscleGain;
      default:
        return '';
    }
  }
}
