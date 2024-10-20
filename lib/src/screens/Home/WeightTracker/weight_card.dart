import 'package:fitelevate/src/screens/Home/WeightTracker/weight_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/path_constants.dart';

class WeightCard extends StatelessWidget {
  const WeightCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: Stack(
        children: [
          Container(
            height:230.0,
            width: 165,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              color: ColorConstants.white,
            ),
          ),
          Positioned(
            top: 2,
            left: 8,
            bottom: 50,
            child: Image.asset(
              PathConstants.weightCard,
              height: 200.0,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
          const Padding(
            padding:  EdgeInsets.all(8.0),
            child: Text("Weight",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),),
          ),
          Positioned(
            bottom: 15,
            left: 10,
            child: Consumer<WeightTrackerProvider>(
              builder: (context, userWeightProvider, child) {
                final currentWeight = userWeightProvider.currentWeightKg;
                final targetWeight=userWeightProvider.targetWeightKg;

                return Column(
                  children: [
                    Text(
                      '$currentWeight Kg',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Goal $targetWeight Kg',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
