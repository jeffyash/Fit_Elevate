import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utils/date_utils.dart';

class CaloriesBurnedProvider with ChangeNotifier {
  double _caloriesBurned = 0;
  double _caloriesGoal = 1000;// Example target calories burned goal
  DateTime _selectedDate = DateTime.now(); // Initialize with current date
  List<String> _workoutTitles = []; // List of workout titles


  String? _userId;

  double get caloriesBurned => _caloriesBurned;
  double get caloriesGoal => _caloriesGoal;
  DateTime get selectedDate => _selectedDate;
  List<String> get workoutTitles => _workoutTitles;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CaloriesBurnedProvider() {
    initialize();
  }
  Future<void> initialize() async {
    _getUserId(); // Ensure _userId is fetched
    fetchCaloriesBurnedForDate(_selectedDate); // Ensure we fetch data for the default date
  }

  void _getUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    } else {
      print('No user is currently signed in.');
    }
  }
  // Method to add a workout title

  void addWorkoutTitle(String title) {
    _workoutTitles.add(title);
    notifyListeners();
  }
  // Method to clear workout titles for a new day
  void clearWorkoutTitles() {
    _workoutTitles.clear();
    notifyListeners();
  }

  void updateCaloriesBurned(double calories) {
    _caloriesBurned += calories; // Increment instead of replace
    notifyListeners();
    _updateCaloriesBurnedInFirestore();
  }
  double get progressValue {
    return _caloriesGoal > 0 ? _caloriesBurned / _caloriesGoal : 0;
  }

  Future<void> fetchCaloriesBurnedForDate(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is currently signed in.');
      return; // Exit if no user is logged in
    }
    _userId = user.uid; // Ensure _userId is set

    try {
      final userDocRef = _firestore.collection('user_master').doc(_userId);
      final dateKey = formatDate(date); // Format the date to use as a key

      final userDoc = await userDocRef.get();
      final currentData = userDoc.data();

      if (currentData != null) {
        final caloriesBurnedData = currentData['caloriesBurned'] as Map?;

        // Set caloriesBurned to 0 if there's no data for the selected date
        if (caloriesBurnedData != null && caloriesBurnedData.containsKey(dateKey)) {
          final dateData = caloriesBurnedData[dateKey] as Map<String, dynamic>;
          final double calories = dateData['caloriesBurned']?.toDouble() ?? 0.0;

          // Update the local state with the fetched data
          _caloriesBurned = calories;
          notifyListeners();

          print('Fetched calories burned for $dateKey: $calories');
        } else {
          // No data for this date, set calories to 0
          _caloriesBurned = 0.0;
          notifyListeners();

          print('No calories burned data found for $dateKey. Defaulting to 0.');
        }
      } else {
        // No data for the user, set calories to 0
        _caloriesBurned = 0.0;
        notifyListeners();

        print('No data found for the user. Defaulting calories burned to 0.');
      }
    } catch (e) {
      print('Error fetching calories burned data from Firestore: $e');
    }
  }

  Future<void> _updateCaloriesBurnedInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is currently signed in.');
      return; // Exit if no user is logged in
    }
    _userId = user.uid; // Ensure _userId is set
    try {
      final userDocRef = _firestore.collection('user_master').doc(_userId);
      // Ensure caloriesBurned is always non-null, defaulting to 0
      final caloriesBurnedData = {
        'caloriesBurned': _caloriesBurned,
      };
      // Prepare the date-based field name
      final dateKey = formatDate(_selectedDate);
      // Debugging output

      final userDoc = await userDocRef.get();
      final currentData = userDoc.data();
      final currentCaloriesBurned = currentData?['caloriesBurned'] as Map? ?? {};

      // Merge the new data with the existing data
      final updatedCaloriesBurned = {
        ...currentCaloriesBurned,
        dateKey: caloriesBurnedData,
      };

      // Update the 'caloriesBurned' map field within the user's document
      await userDocRef.update({
        'caloriesBurned': updatedCaloriesBurned,
      }); // Merge to update existing data without overwriting

      print('Firestore document updated successfully.');
    } catch (e) {
      print('Error updating calories burned in Firestore: $e');
    }
  }


  bool isSameDay(DateTime date1, DateTime date2) {
    return
      date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
  String getDateTitle() {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (isSameDay(_selectedDate, today)) {
      return 'Today';
    } else if (isSameDay(_selectedDate, yesterday)) {
      return 'Yesterday';
    } else {
      return formatDate(_selectedDate);
    }
  }
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    fetchCaloriesBurnedForDate(_selectedDate); // Fetch data from Firestore for the selected date
    notifyListeners();
  }
  void resetToDefaults() {
    _caloriesBurned=0;
    notifyListeners();
  }
}
