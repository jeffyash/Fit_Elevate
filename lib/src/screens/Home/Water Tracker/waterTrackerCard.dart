import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/path_constants.dart';
import 'water_tracking_provider.dart';

class WaterTrackerCard extends StatelessWidget {
  const WaterTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
              bottom: Radius.circular(16.0),
            ),
            child: Image.asset(
              PathConstants.water,
              height: 235.0,
              width: 165,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Water",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 10,
            child: Consumer<WaterIntakeProvider>(
              builder: (context, waterIntakeProvider, child) {
                final totalWaterConsumed = waterIntakeProvider.totalWaterConsumed;
                final dailyWaterGoal = waterIntakeProvider.dailyWaterIntake / 1000.0;

                return Column(
                  children: [
                    Text(
                      '$totalWaterConsumed ml',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Daily Goal: $dailyWaterGoal L',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
