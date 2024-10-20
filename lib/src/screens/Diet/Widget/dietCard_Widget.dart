import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:flutter/material.dart';
import '../../../models/diet_data.dart';
class DietPlanCard extends StatelessWidget {
  final DietPlanData dietPlan;
  const DietPlanCard({Key? key, required this.dietPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Image.asset(
              dietPlan.image,
              height: 160.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dietPlan.title,
              style: TextStyle(
                fontSize: 18.0,
                color: ColorConstants.textBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
