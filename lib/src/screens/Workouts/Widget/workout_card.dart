import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/models/workout_data.dart';
import 'package:flutter/material.dart';

import '../../../constants/workout_constants.dart';
import '../workout_detailPage.dart';

class WorkoutCard extends StatelessWidget {
  final List<WorkoutData> workoutTypes; // accept a list of WorkoutData

  const WorkoutCard({Key? key, required this.workoutTypes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workoutTypes.length,
      itemBuilder: (context, index) {
        final workout = workoutTypes[index];
        return InkWell(
          onTap: () {
            List<ExercisesData> selectedWorkouts = [];

            switch (workout.title) {
              case 'Strength Training':
                selectedWorkouts = WorkoutConstants().strengthTraining;
                break;
              case 'Cardio Workout':
                selectedWorkouts = WorkoutConstants().cardioWorkout;
                break;
              case 'Zumba':
                selectedWorkouts = WorkoutConstants().zumba;
                break;
              case 'Yoga':
                selectedWorkouts = WorkoutConstants().yoga;
                break;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetailScreen(exercisesList: selectedWorkouts,
                  title: workout.title, // Pass the title here
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250, // Adjust the height as needed
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      workout.image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: ColorConstants.primaryColor.withOpacity(0.6),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          workout.subtitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
