import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'userinfo_provider.dart';

class ActivityLevel extends StatelessWidget {
  const ActivityLevel({super.key});

  @override
  Widget build(BuildContext context) {
    final userActivity = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              TextConstants.activity_title,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                TextConstants.activity_subtitle,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            _buildActivityButton(
                'Sedentary',
                TextConstants.sedentary,
                TextConstants.sedentary_sub,
                userActivity
            ),
            const SizedBox(height: 15),
            _buildActivityButton(
                'Lightly Active',
                TextConstants.lightlyactive,
                TextConstants.lightlyactive_sub,
                userActivity
            ),
            const SizedBox(height: 15),
            _buildActivityButton(
                'Moderately Active',
                TextConstants.moderately,
                TextConstants.moderately_sub,
                userActivity
            ),
            const SizedBox(height: 15),
            _buildActivityButton(
                'Very Active',
                TextConstants.veryactive,
                TextConstants.veryactive_sub,
                userActivity
            ),
            const SizedBox(height: 15),
            _buildActivityButton(
                'Super Active',
                TextConstants.superactive,
                TextConstants.superactive_sub,
                userActivity
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildActivityButton(
      String level,
      String title,
      String subtitle,
      UserInfoProvider userActivity
      ) {
    final isSelected = userActivity.activityLevel == level;

    return SizedBox(
      width: 300,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? ColorConstants.primaryColor
              : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
        ),
        onPressed: () {
          userActivity.activityLevel = level; // Update activity level in provider
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
