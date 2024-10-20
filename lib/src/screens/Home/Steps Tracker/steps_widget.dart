import 'package:fitelevate/src/screens/Home/Steps%20Tracker/steps_daily_track_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/text_constants.dart';

class StepCountProgress extends StatelessWidget {
  const StepCountProgress({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height and width using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Use Consumer to listen to changes in StepsTrackingProvider
    return Consumer<StepsDailyTrackingProvider>(
      builder: (context, stepCountProvider, child) {

        final int steps = stepCountProvider.todaySteps;
        final int stepGoal = stepCountProvider.dailyStepGoal;
        final double progressValue = stepGoal > 0 ? steps / stepGoal : 0.0;

        return Container(
          width: double.infinity,
          height: screenHeight * 0.4, // Adjust container height based on screen height
          child: Stack(
            children: [
              Positioned(
                top: screenHeight * 0.05, // Adjust top position for the CircularProgressIndicator
                right: screenWidth * 0.25, // Adjust right position for the CircularProgressIndicator
                child: SizedBox(
                  width: screenWidth * 0.5, // CircularProgressIndicator width based on screen width
                  height: screenWidth * 0.5, // CircularProgressIndicator height based on screen width
                  child: CircularProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ColorConstants.primaryColor),
                    strokeWidth: 8,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.1, // Adjust top position based on screen height
                right: screenWidth * 0.4, // Adjust right position based on screen width
                child: Column(
                  children: [
                    Text(
                      TextConstants.steps,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, // Font size based on screen width
                      ),
                    ),
                    Text(
                      '$steps',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08, // Font size based on screen width
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/$stepGoal',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Font size based on screen width
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.3, // Adjust top position for the Icon
                right: screenWidth * 0.40, // Adjust right position for the Icon
                child: Icon(
                  stepCountProvider.pedestrianStatus == 'walking'
                      ? Icons.directions_walk
                      : stepCountProvider.pedestrianStatus == 'stopped'
                      ? Icons.accessibility_new
                      : Icons.error,
                  size: screenWidth * 0.15, // Icon size based on screen width
                  color: ColorConstants.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
