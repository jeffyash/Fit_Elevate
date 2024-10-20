import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/food_model.dart';

class MealCalorieTracker with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Map to hold a list of Food objects for each meal type
  final Map<String, List<Food>> _mealFoods = {
    'breakfast': [],
    'lunch': [],
    'dinner': [],
    'snacks': [],
  };

  MealCalorieTracker() {
    _getUserId();
    fetchMealsForDate(selectedDate);
  }

  DateTime get selectedDate => _selectedDate;
  String? _userId; // Declare userId as a nullable String

  // Method to get user ID from FirebaseAuth
  void _getUserId() {
    User? user = _auth.currentUser; // Get the currently signed-in user
    if (user != null) {
      _userId = user.uid; // Set userId
    } else {
      print('No user is currently signed in.');
    }
  }

  // Method to add food to a specific meal type and update Firestore
  void addFood(String mealType, Food food) {
    // Check if the meal type exists, if not initialize it
    if (!_mealFoods.containsKey(mealType)) {
      print('Initializing meal type: $mealType');
      _mealFoods[mealType] = []; // Initialize with an empty list if not present
    }

    // Add the food to the specified meal type
    _mealFoods[mealType]!.add(food);

    // Notify listeners to trigger UI updates
    notifyListeners();

    // Update Firestore whenever food is added
    _updateMealsInFirestore();
  }
  void deleteFood(String mealType, Food food) {
    if (_mealFoods.containsKey(mealType)) {
      _mealFoods[mealType]!.remove(food);  // Remove the food from the meal
      notifyListeners();
      _updateMealsInFirestore();  // Update Firestore after deleting the food
    } else {
      print('Meal type not found: $mealType');
    }
  }


  // Method to calculate total calories for a specific meal type
  int getTotalCaloriesForMeal(String mealType) {
    return _mealFoods[mealType]?.fold(0, (sum, food) => sum! + food.calories) ?? 0;
  }

  // Method to calculate total calories for all meals
  int getTotalCaloriesForAllMeals() {
    return _mealFoods.values
        .fold(0, (sum, foods) => sum + foods.fold(0, (mealSum, food) => mealSum + food.calories));
  }

  // Method to reset calories for all meal types and update Firestore
  void resetCalories() {
    _mealFoods.updateAll((key, value) => []);
    notifyListeners();
    _updateMealsInFirestore(); // Update Firestore after resetting meals
  }

  // Helper method to check if two dates are the same
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  // Helper method to format dates
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  // Method to get the title for the selected date
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

  // Method to update the selected date and notify listeners
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    fetchMealsForDate(date);
    notifyListeners();
  }

  // Getter to retrieve the entire map of foods
  Map<String, List<Food>> get mealFoods => _mealFoods;

  // Method to convert all foods in a meal type to a map format
  Map<String, dynamic> toMap() {
    return {
      'date': _selectedDate.toIso8601String(),
      'meals': _mealFoods.map((mealType, foods) => MapEntry(
        mealType,
        foods.map((food) => food.toMap()).toList(),
      )),
    };
  }

  // Private method to update Firestore with the current state of meal data
  Future<void> _updateMealsInFirestore() async {
    if (_userId == null) {
      print('No user is currently signed in.');
      return;
    }

    try {
      final userDocRef = _firestore.collection('user_master').doc(_userId);
      final dateKey = formatDate(_selectedDate); // Format the date as a key (e.g., '2023-09-24')
      print('Updating Firestore document for meals on $dateKey');

      final mealsData = _mealFoods.map((mealType, foods) {
        return MapEntry(
          mealType,
          {'foods': foods.map((food) => food.toMap()).toList()},
        );
      });

      // Update Firestore using merge to ensure it doesn't overwrite existing data
      await userDocRef.set({
        'dailyMeals': {
          dateKey: mealsData,
        },
      }, SetOptions(merge: true)); // Use merge to only update the specific day's meals

      print('Firestore document updated successfully for $dateKey.');
    } catch (e) {
      print('Error updating meals in Firestore: $e');
    }
  }

  Future<void> fetchMealsForDate(DateTime date) async {
    if (_userId == null) {
      print('No user is currently signed in.');
      return;
    }

    try {
      final userDocRef = _firestore.collection('user_master').doc(_userId);
      final dateKey = formatDate(date); // Format the selected date

      // Fetch the user document from Firestore
      final snapshot = await userDocRef.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        final dailyMealsMap = data?['dailyMeals'] as Map<String, dynamic>?;

        if (dailyMealsMap != null && dailyMealsMap[dateKey] != null) {
          // Extract the meals data for the specific date
          final dailyMealsData = dailyMealsMap[dateKey] as Map<String, dynamic>;

          // Update _mealFoods by iterating over the meal types in dailyMealsData
          final updatedMealFoods = dailyMealsData.map((mealType, mealData) {
            // Make sure mealData['foods'] is a list before processing
            final foods = (mealData['foods'] as List<dynamic>?)
                ?.map((food) => Food.fromMap(food as Map<String, dynamic>))
                .toList() ?? [];

            return MapEntry(mealType, foods);
          });

          // Replace the old meal data with the new data for the selected date
          _mealFoods.clear();
          _mealFoods.addAll(updatedMealFoods);
          print('Meals for $dateKey fetched successfully.');
        } else {
          // If no meals exist for the selected date, clear the meal data
          _mealFoods.clear();
          print('No meals found for $dateKey.');
        }
      } else {
        print('User document does not exist.');
        _mealFoods.clear();
      }
    } catch (e) {
      print('Error fetching meals data: $e');
      _mealFoods.clear();
    }

    // Notify listeners to update the UI
    notifyListeners();
  }

}
