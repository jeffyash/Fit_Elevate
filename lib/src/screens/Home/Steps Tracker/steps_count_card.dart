import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import 'steps_daily_track_provider.dart';

class StepsCountCard extends StatelessWidget {
  const StepsCountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final stepCountProvider = Provider.of<StepsDailyTrackingProvider>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: Stack(
        children: [
          Container(
            height: 230.0,
            width: 165,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              color: ColorConstants.white,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Steps",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Positioned(
            top: 80,
            left: 58,
            child: Icon(Ionicons.footsteps_sharp, size: 35),
          ),
          Positioned(
            top: 50,
            left: 25,
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: stepCountProvider.getProgress(),
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.primaryColor),
                strokeWidth: 7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
