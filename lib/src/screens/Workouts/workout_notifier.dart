import 'package:flutter/material.dart';

import '../../models/workout_data.dart';

class WorkoutsProvider with ChangeNotifier {
  WorkoutData? _workout;
  WorkoutData? _selectedWorkout;

  WorkoutData? get workout => _workout;
  WorkoutData? get selectedWorkout => _selectedWorkout;

  void cardTapped(WorkoutData workout) {
    _workout = workout;
    notifyListeners();
  }
  void selectWorkout(WorkoutData workout) {
    _selectedWorkout = workout;
    notifyListeners();
  }
  void resetWorkout() {
    _selectedWorkout = null;
    notifyListeners();
  }
}
