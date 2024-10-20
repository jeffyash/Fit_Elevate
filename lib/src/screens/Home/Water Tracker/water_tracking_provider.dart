import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../UserProfileSetup/userinfo_provider.dart';

class WaterIntakeProvider with ChangeNotifier {
  int _dailyWaterIntake = 2000;
  int _totalWaterConsumed = 0;
  int _glassesConsumed = 0;
  Map<DateTime, int> _dailyWaterConsumptionMap = {}; // New map to track daily intake
  DateTime _selectedDate = DateTime.now();
  DateTime _accountCreateDate = DateTime.now();
  Map<DateTime, int> _waterIntakeData = {};



  int get dailyWaterIntake => _dailyWaterIntake;
  int get totalWaterConsumed => _totalWaterConsumed;
  int get glassesConsumed => _glassesConsumed;
  Map<DateTime, int> get dailyWaterConsumptionMap => _dailyWaterConsumptionMap;
  DateTime get selectedDate => _selectedDate;
  DateTime get accountCreateDate => _accountCreateDate;
  Map<DateTime, int> get waterIntakeData => _waterIntakeData;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SharedPreferences? _prefs;

  String? _userId; // Declare userId as a nullable String

  WaterIntakeProvider() {
    initialize();
    fetchWaterIntakeData();
  }

  // Initialize shared preferences, user id, check for a new day,account creation date, load water consumption
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _getUserId();
    _checkForNewDay(); // Check for a new day when initializing
    fetchAccountCreationDate();
    _loadWaterConsumptionMap(); // Load water intake map
    fetchWaterIntakeData();
    fetchWaterIntakeForDate(_selectedDate); // Ensure we fetch data for the default date

  }

  // Method to get user ID from FirebaseAuth
  void _getUserId() {
    User? user = _auth.currentUser; // Get the currently signed-in user
    if (user != null) {
      _userId = user.uid; // Set userId
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> fetchAccountCreationDate() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userDoc = await _firestore.collection('user_master').doc(userId).get();
        if (userDoc.exists && userDoc.data() != null) {
          final profileData = userDoc.data()!['profile'];
          if (profileData != null && profileData['createdAt'] != null) {
            _accountCreateDate = (profileData['createdAt'] as Timestamp).toDate();
            _prefs?.setString('accountCreationDate', _accountCreateDate.toIso8601String());
          }
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Failed to fetch account creation date: $e');
    }
    notifyListeners();
  }

  // Check if the current day is different from the last recorded day
  void _checkForNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRecordedDateString = prefs.getString('lastRecordedDate');
    final currentDate = DateTime.now();

    if (lastRecordedDateString != null) {
      final lastRecordedDate = DateTime.parse(lastRecordedDateString);
      if (!isSameDay(lastRecordedDate, currentDate)) {
        // If it's a new day, reset water intake
        resetWater(); // Reset local values
        await _updateWaterIntakeInFirestore(); // Update Firestore to reset to 0 for new day
        await prefs.setString('lastRecordedDate', currentDate.toIso8601String()); // Update last recorded date
      }
    } else {
      // If it's the first time running, set the current date as the last recorded date
      await prefs.setString('lastRecordedDate', currentDate.toIso8601String());
    }
  }

  // Load the water consumption data from SharedPreferences into the map
  Future<void> _loadWaterConsumptionMap() async {
    final prefs = await SharedPreferences.getInstance();
    final consumptionDataString = prefs.getString('dailyWaterConsumptionMap');

    if (consumptionDataString != null) {
      final consumptionData = Map<String, int>.from(await jsonDecode(consumptionDataString));
      _dailyWaterConsumptionMap = consumptionData.map((dateString, intake) =>
          MapEntry(DateTime.parse(dateString), intake));
      _totalWaterConsumed = _dailyWaterConsumptionMap[_selectedDate] ?? 0;
    } else {
      _totalWaterConsumed = 0;
    }
    notifyListeners();
  }

  Future<void> addWater(int ml) async {
    _checkForNewDay(); // Check for a new day when adding water

    if (ml <= 0) {
      print('Invalid amount. Please enter a positive value.');
      return; // Exit if the amount to add is not positive
    }

    _totalWaterConsumed += ml;
    _glassesConsumed = (_totalWaterConsumed ~/ 250).round(); // Calculate glasses based on total water consumed

    // Update the map with the new water intake value
    _dailyWaterConsumptionMap[_selectedDate] = _totalWaterConsumed;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dailyWaterConsumptionMap', jsonEncode(_dailyWaterConsumptionMap.map((date, intake) => MapEntry(date.toIso8601String(), intake))));

    await _updateWaterIntakeInFirestore(); // Save to Firestore
    print('Total Water Consumed $_totalWaterConsumed ml');
    notifyListeners();
  }

  Future<void> removeWater(int ml) async {
    _checkForNewDay(); // Check for a new day when removing water

    if (ml <= 0) {
      print('Invalid amount. Please enter a positive value.');
      return; // Exit if the amount to remove is not positive
    }

    if (_totalWaterConsumed >= ml) {
      _totalWaterConsumed -= ml;
      _glassesConsumed = (_totalWaterConsumed ~/ 250).round(); // Ensure glasses consumed is non-negative

      // Update the map with the new water intake value
      _dailyWaterConsumptionMap[_selectedDate] = _totalWaterConsumed;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dailyWaterConsumptionMap', jsonEncode(_dailyWaterConsumptionMap.map((date, intake) => MapEntry(date.toIso8601String(), intake))));

      await _updateWaterIntakeInFirestore(); // Save to Firestore
      print('Total Water Consumed $_totalWaterConsumed ml');
    } else {
      print('Not enough water consumed to remove that amount.');
    }

    notifyListeners();
  }

  Future<void> resetWater() async {
    _totalWaterConsumed = 0;
    _glassesConsumed = 0;

    // Reset the map for the selected date (which should be the new day)
    _dailyWaterConsumptionMap[_selectedDate] = 0;

    // Update SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'dailyWaterConsumptionMap',
      jsonEncode(_dailyWaterConsumptionMap.map((date, intake) => MapEntry(date.toIso8601String(), intake))),
    );

    // Update Firestore
    await _updateWaterIntakeInFirestore();
    notifyListeners();
  }

  // Private method to update Firestore with the current state of water intake data
  Future<void> _updateWaterIntakeInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is currently signed in.');
      return; // Exit if no user is logged in
    }

    _userId = user.uid; // Ensure _userId is set

    try {
      final userDocRef = _firestore.collection('user_master').doc(_userId);
      final dateKey = formatDate(_selectedDate); // Format the current date

      // Retrieve the current water intake data from Firestore
      final userDoc = await userDocRef.get();
      final currentData = userDoc.data();
      final currentWaterIntake = currentData?['waterIntake'] as Map<String, dynamic>? ?? {};

      final lastRecordedDate = currentData?['lastRecordedDate'] as String?;

      if (lastRecordedDate != dateKey) {
        // If it's a new day, reset values
        _totalWaterConsumed = 0;
        _glassesConsumed = 0;

        await userDocRef.update({
          'waterIntake': {
            ...currentWaterIntake,
            dateKey: {
              'totalWaterConsumed': _totalWaterConsumed,
              'glassesConsumed': _glassesConsumed,
            },
          },
          'lastRecordedDate': dateKey,
        });

        print('Firestore updated for the new day with reset values.');
      } else {
        // Otherwise, just update the current values
        final waterIntakeData = {
          'totalWaterConsumed': _totalWaterConsumed,
          'glassesConsumed': _glassesConsumed,
        };

        final updatedWaterIntake = {
          ...currentWaterIntake,
          dateKey: waterIntakeData,
        };

        await userDocRef.update({
          'waterIntake': updatedWaterIntake,
        });

        print('Firestore updated successfully.');
      }
    } catch (e) {
      print('Error updating water intake in Firestore: $e');
    }
  }

// Fetching WaterIntake for selected dates
  Future<void> fetchWaterIntakeForDate(DateTime date) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userDocRef = _firestore.collection('user_master').doc(userId);

        // Format the date
        String dateKey = formatDate(date);
        // Fetch the document
        final snapshot = await userDocRef.get();

        if (snapshot.exists) {
          final data = snapshot.data();
          print('Document data: $data'); // Debugging output

          final waterIntakeMap = data?['waterIntake'] as Map<String, dynamic>?;

          if (waterIntakeMap != null) {
            print('Water intake map: $waterIntakeMap'); // Debugging output

            if (waterIntakeMap.containsKey(dateKey)) {
              // Fetch data using the dateKey
              final dailyIntakeData = waterIntakeMap[dateKey] as Map<String, dynamic>;
              _totalWaterConsumed = dailyIntakeData['totalWaterConsumed'] ?? 0;
              _glassesConsumed = dailyIntakeData['glassesConsumed'] ?? 0;

            } else {
              // If no data exists for the selected date, reset values to zero
              _totalWaterConsumed = 0;
              _glassesConsumed = 0;
            }
          } else {
            // If waterIntake map is null, reset values to zero
            _totalWaterConsumed = 0;
            _glassesConsumed = 0;
          }
        } else {
          print('Document does not exist'); // Debugging output
          // If the document doesn't exist, reset values to zero
          _totalWaterConsumed = 0;
          _glassesConsumed = 0;
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error fetching water intake data: $e');
    }
    notifyListeners();
  }

  Future<void> fetchWaterIntakeData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final userDocRef = _firestore.collection('user_master').doc(user.uid);
        final snapshot = await userDocRef.get();

        if (snapshot.exists) {
          // Fetching the 'waterIntake' field from Firestore
          final data = snapshot.data()?['waterIntake'] as Map<String, dynamic>?;

          // Initialize the start date and end date
          DateTime startDate = _accountCreateDate; // Fallback to now if not set
          DateTime endDate = DateTime.now();

          // Initialize the water intake data map
          _waterIntakeData = {};

          // If data exists, map it to _waterIntakeData
          if (data != null) {
            _waterIntakeData = data.map((dateKey, intake) {
              // Adjust the date parsing according to your Firestore format
              DateTime date = DateFormat('dd-MM-yyyy').parse(dateKey);
              Map<String, dynamic> intakeData = intake as Map<String, dynamic>;
              int glassesConsumed = intakeData['glassesConsumed'] ?? 0;
              return MapEntry(DateTime(date.year, date.month, date.day), glassesConsumed); // Normalize to date only
            });
          }

          // Fill in missing dates with 0 glasses consumed
          // for (DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
          //   if (!_waterIntakeData.containsKey(DateTime(date.year, date.month, date.day))) {
          //     _waterIntakeData[DateTime(date.year, date.month, date.day)] = 0; // Default to 0 if no entry exists
          //   }
          // }
          for (DateTime date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
            if (!_waterIntakeData.containsKey(DateTime(date.year, date.month, date.day))) {
              _waterIntakeData[DateTime(date.year, date.month, date.day)] = 0; // Default to 0 if no entry exists
            }
          }


          // Sort the map by date keys
          _waterIntakeData = Map.fromEntries(
            _waterIntakeData.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
          );
        } else {
          // Handle case where document doesn't exist
          _waterIntakeData = {};
        }

        notifyListeners(); // Notify listeners after data is updated
      } catch (e) {
        print('Error fetching water intake data: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }


// Daily Water Intake according to weight
  void updateDailyWaterIntake(UserInfoProvider userInfoProvider) {
    _dailyWaterIntake = calculateDailyWaterIntake(userInfoProvider.weightKg).toInt();
    notifyListeners();
  }

  double calculateDailyWaterIntake(double weightKg) {
    return weightKg * 30; // Using 30 ml/kg as a base
  }

// Calendar

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
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
    // Fetch data for the selected date
    fetchWaterIntakeForDate(_selectedDate);
    // Notify listeners to update the UI
    notifyListeners();
    print('Updating selected date: $date');
  }

  void resetToDefaults() {
    _totalWaterConsumed=0;
    _glassesConsumed=0;
    notifyListeners();
  }
}
