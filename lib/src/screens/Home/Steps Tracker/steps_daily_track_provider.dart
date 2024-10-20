import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_pedometer2/daily_pedometer2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class StepsDailyTrackingProvider with ChangeNotifier {
  late Stream<StepCount> _dailyStepCountStream;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  int _todaySteps = 0;  
  int _currentSteps = 0;
  String _pedestrianStatus = 'Unknown';
  int _dailyStepGoal = 10000; // Set daily step goal to 10,000 steps
  Map<DateTime, int> _stepsWalkedData = {};
  DateTime _selectedDate = DateTime.now();
  DateTime _accountCreationDate = DateTime.now();
  String? _userId;

  // Getters for the current steps, today's steps, pedestrian status, and goal status
  int get todaySteps => _todaySteps;
  int get currentSteps => _currentSteps;
  String get pedestrianStatus => _pedestrianStatus;
  int get dailyStepGoal => _dailyStepGoal;
  Map<DateTime, int> get stepsWalkedData => _stepsWalkedData;
  DateTime get selectedDate => _selectedDate;
  DateTime get accountCreationDate => _accountCreationDate;

  void _getUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    } else {
      print('No user is currently signed in.');
    }
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Constructor to initialize step tracking
  StepsDailyTrackingProvider() {
    initPlatformState();
    fetchAllStepsData();
  }

  // Future<void> initialize() async {
  //   _getUserId();
  //   resetToDefaults();  // Reset any stored data for new user
  //   fetchAccountCreationDate();
  //   initPlatformState();
  //   fetchStepsForSelectedDate();
  //   fetchAllStepsData();
  // }

  Future<void> initialize() async {
    _getUserId();
    if (_userId != null) {
      // Only reset to defaults if the user ID is available
      resetToDefaults();  // Reset any stored data for new user
      fetchAccountCreationDate();
      fetchStepsForSelectedDate();
      fetchAllStepsData();
    } else {
      print('No user is currently signed in, so steps will not be reset.');
    }
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      print('Activity recognition permission is not granted.');
      return;
    }
    // Init streams from daily pedometer2 package
    _pedestrianStatusStream = DailyPedometer2.pedestrianStatusStream;
    _stepCountStream = DailyPedometer2.stepCountStream;
    _dailyStepCountStream = DailyPedometer2.dailyStepCountStream;

    // Listen to pedestrian status changes
    _pedestrianStatusStream.listen((PedestrianStatus status) {
      _pedestrianStatus = status.status;  // Extract the status and assign
      notifyListeners();
    }).onError((error) {
      print('Pedestrian status error: $error');
    });

    // Listen to current step count
    _stepCountStream.listen((StepCount steps) {
      _currentSteps = steps.steps;  // Extract steps and assign as int
      notifyListeners();
    }).onError((error) {
      print('Step count error: $error');
    });

    // Listen to today's step count
    _dailyStepCountStream.listen((StepCount dailySteps) {
      print("Raw step count: ${dailySteps.steps}");
      _todaySteps = dailySteps.steps >= 0 ? dailySteps.steps : 0; // Prevent negative values
      print("Corrected step count: $_todaySteps");
      _updateStepCountInFirestore(); // Update Firestore on new step data
      notifyListeners();
    });

  }

  Future<bool> _checkActivityRecognitionPermission() async {
    PermissionStatus status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      status = await Permission.activityRecognition.request();
    }
    return status.isGranted;
  }

  Future<void> fetchAccountCreationDate() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final _userId = user.uid;
        final userDoc = await _firestore.collection('user_master').doc(_userId).get();
        if (userDoc.exists && userDoc.data() != null) {
          final profileData = userDoc.data()!['profile'];
          if (profileData != null && profileData['createdAt'] != null) {
            _accountCreationDate = (profileData['createdAt'] as Timestamp).toDate();
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

  Future<void> _updateStepCountInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is currently signed in.');
      return; // Exit if no user is logged in
    }

    _userId = user.uid; // Ensure _userId is set
    try {
      final userDocRef = _firestore.collection('user_master').doc(_userId);
      final dateKey = formatDate(_selectedDate); // Format date correctly

      // Fetch current user data from Firestore
      final userDoc = await userDocRef.get();
      final currentData = userDoc.data()  ?? {};
      final currentStepCount = currentData['stepsWalked'] as Map<String, dynamic>? ?? {};
      final lastStepsRecordedDate = currentData['lastStepsRecordedDate'] as String? ?? "";

      // If it's a new day, reset the daily steps to 0
      if (lastStepsRecordedDate != dateKey) {
        _todaySteps = 0; // Reset today's steps
        await userDocRef.set({  // Use set to create a new user document if it doesn't exist
          'stepsWalked': {
            dateKey: {
              'stepsWalked': _todaySteps,
            },
          },
          'lastStepsRecordedDate': dateKey,
        }, SetOptions(merge: true)); // Merge the data

        print('Firestore updated for the new day with reset values.');
      } else {
        // If it's the same day, update the steps count
        final stepsWalkedData = {
          'stepsWalked': _todaySteps,
        };

        // Merge the new steps with existing steps data
        final updatedStepCount = {
          ...currentStepCount,
          dateKey: stepsWalkedData,
        };

        // Update Firestore with the new step count
        await userDocRef.update({
          'stepsWalked': updatedStepCount,
        });

        print('Firestore document updated successfully.');
      }
    } catch (e) {
      print('Error updating step count in Firestore: $e');
    }
  }

  Future<void> fetchStepsForSelectedDate() async {
    try {
      // Ensure that the user is logged in
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is currently signed in.');
        return;
      }

      // Get the user's Firestore document
      final userDocRef = _firestore.collection('user_master').doc(user.uid);
      final userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;

        // Check if 'stepsWalked' data exists in the document
        if (data.containsKey('stepsWalked')) {
          final stepsWalkedData = data['stepsWalked'] as Map<String, dynamic>;

          // Format the selected date to match the Firestore keys (e.g., 'January 1, 2024')
          final selectedDateKey = formatDate(_selectedDate);

          // Check if steps data for the selected date exists
          if (stepsWalkedData.containsKey(selectedDateKey)) {
            final stepData = stepsWalkedData[selectedDateKey] as Map<String, dynamic>;
            _todaySteps = stepData['stepsWalked'] ?? 0;
            print('Steps for $_selectedDate: $_todaySteps');
          } else {
            print('No steps data found for the selected date: $selectedDateKey');
            _todaySteps = 0; // Reset if no data for the selected date
          }
        } else {
          print('No steps data found in Firestore.');
        }
      } else {
        print('No user data found in Firestore.');
      }

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      print('Failed to fetch steps data for selected date: $e');
    }
  }
  Future<void> fetchAllStepsData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      _stepsWalkedData = {};  // Reset steps data for new user
      try{
        final userDocRef = _firestore.collection('user_master').doc(user.uid);
        print('Fetching steps data for user: ${user.uid}');
        final snapshot = await userDocRef.get();
        print('Document fetched from Firestore.');

        if(snapshot.exists){
          print(("User document exists"));
          final data = snapshot.data()?['stepsWalked'] as Map<String, dynamic>?;
          print('Steps walked data: $data');
          // Initialize the start and end dates
          DateTime startDate = _accountCreationDate;
          DateTime endDate = DateTime.now();
          print('Start date: $startDate, End date: $endDate');
          // Initialize the stepsWalked data map
          _stepsWalkedData = {};
          // If steps data exists, map it to _stepsWalkedDat
          if(data!=null){
            _stepsWalkedData=data.map((dateKey, stepCount){
              DateTime date;
              // Parse the date string in the format 'MMMM d, yyyy'
              date = DateFormat('MMMM d, yyyy').parse(dateKey);
              // Extract steps data
              Map<String, dynamic> walkedData = stepCount as Map<String, dynamic>;
              int todaySteps = walkedData['stepsWalked'] ?? 0;
              print('Steps for $dateKey: $todaySteps');
              return MapEntry(DateTime(date.year, date.month, date.day), todaySteps);
            });
          }else{
            print("No steps data available in the user document");
          }
          // Fill in missing dates with 0 steps walked
          for (DateTime date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
            if (!_stepsWalkedData.containsKey(DateTime(date.year, date.month, date.day))) {
              _stepsWalkedData[DateTime(date.year, date.month, date.day)] = 0;
              print('No data for ${DateFormat('MMMM d, yyyy').format(date)}, setting steps to 0');
            }
          }
          //Sort the map by date keys
          _stepsWalkedData=Map.fromEntries(
            _stepsWalkedData.entries.toList()
              ..sort((a,b)=>a.key.compareTo(b.key)),
          );
          print('Steps data sorted by date');
        }else{
          print("User document does not exist");
          _stepsWalkedData={};
        }

        notifyListeners();//notify listeners to update  the UI
        print('Data successfully fetched and listeners notified.');
      }catch(e){
        print('Error fetching step count from Firestore: $e');
      }
    }else{
      print('No user is currently signed in.');
    }
  }

  void setStepGoal(int goal) {
    _dailyStepGoal = goal;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    // Fetch data for the selected date
    fetchStepsForSelectedDate();
    // Notify listeners to update the UI
    notifyListeners();
    print('Updating selected date: $date');
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String getDateTitle(DateTime date) {
    if (isSameDay(date, DateTime.now())) {
      return 'Today'; // Display 'Today' if the selected date is today
    } else {
      return DateFormat('EEEE, MMM d').format(date); // Format other dates as 'Monday, Jan 1'
    }
  }

  double getProgress() {
    return (_todaySteps / _dailyStepGoal).clamp(0.0, 1.0);
  }

  bool hasReachedGoal() {
    return _todaySteps >= _dailyStepGoal;
  }

  // Methods to reset to default values
  void resetToDefaults() {
   _todaySteps=0;
   _currentSteps=0;
    notifyListeners();
  }
}
