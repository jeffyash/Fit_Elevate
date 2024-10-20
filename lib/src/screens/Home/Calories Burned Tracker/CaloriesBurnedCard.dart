import 'package:fitelevate/src/screens/Home/Calories%20Burned%20Tracker/CaloriesBurnedDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import 'CaloriesBurnedProvider.dart';
class CaloriesBurned extends StatelessWidget {
  final double progressValue;

  const CaloriesBurned({super.key, required this.progressValue});


  @override
  Widget build(BuildContext context) {
       // Calculate progress value as a fraction of the goal
    double progressValue = Provider.of<CaloriesBurnedProvider>(context).progressValue;
    double caloriesBurned = Provider.of<CaloriesBurnedProvider>(context).caloriesBurned;

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaloriesBurnedDetails()
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
        child: Stack(
          children: [
            Container(
              height:230.0,
              width: 165,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: ColorConstants.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Calories Burned",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            Positioned(
                top: 80,
                left: 58,
                child: Icon(Icons.local_fire_department_sharp,
                color: ColorConstants.iconOrange,
                size: 40,)
            ),
            Positioned(
              top: 50,
              left: 25,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey.shade300,
                  valueColor:  AlwaysStoppedAnimation<Color>(ColorConstants.primaryColor),
                  strokeWidth: 7,
                ),
              ),
            ),
            Positioned(
              bottom:20,
                left: 30,
                child: Text("${caloriesBurned.toStringAsFixed(0)} cal burned")),
          ],

        ),
      ),
    );
  }
}
