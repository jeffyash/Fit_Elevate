import 'package:fitelevate/src/constants/workout_constants.dart';
import 'package:flutter/material.dart';
import 'Widget/workout_card.dart';

class Workouts extends StatelessWidget {
  const Workouts({super.key});
  @override
  Widget build(BuildContext context) {
    final workoutType=WorkoutConstants.workoutData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: WorkoutCard(workoutTypes:workoutType),  // Passing the workoutData list
    );
  }
}
