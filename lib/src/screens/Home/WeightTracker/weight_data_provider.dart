import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitelevate/utils/date_utils.dart';
import 'package:flutter/material.dart';

class WeightTrackerProvider extends ChangeNotifier {
  double _initialWeight = 0.0;
  double _currentWeightKg = 0.0;
  double _targetWeightKg = 0.0;
  String _goal='';
  List<Map<String, dynamic>> _weightHistory = []; // List to store weight and date history

  String? _userId;

  double get initialWeight => double.parse(_initialWeight.toStringAsFixed(2));
  double get currentWeightKg => double.parse(_currentWeightKg.toStringAsFixed(2));
  double get targetWeightKg => double.parse(_targetWeightKg.toStringAsFixed(2));
  String get  goal=>_goal;
  List<Map<String, dynamic>> get weightHistory => _weightHistory;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    _getUserId(); // Ensure _userId is fetched
    fetchUserWeightData(_userId!);
  }

  void _getUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> fetchUserWeightData(String userId) async {
    try {
      final userDoc = await _firestore.collection('user_master').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final weightData = userDoc.data()!['physicalAttributes'];
        if (weightData != null) {
          // Use as double with rounding to 2 decimal places
          _currentWeightKg = double.parse((weightData['weightKg'] as num).toDouble().toStringAsFixed(2));
          _targetWeightKg = double.parse((weightData['targetWeightKg'] as num).toDouble().toStringAsFixed(2));
          _goal=weightData['goal'];

          if (weightData['weightHistory'] != null) {
            _weightHistory = List<Map<String, dynamic>>.from(
              weightData['weightHistory'].map((e) => {
                'weight': double.parse((e['weight'] as num).toDouble().toStringAsFixed(2)),
                'date': e['date'],
              }),
            );

            if (weightData['initialWeight'] != null) {
              _initialWeight = double.parse((weightData['initialWeight'] as num).toDouble().toStringAsFixed(2));
            } else {
              if (_weightHistory.isNotEmpty) {
                _initialWeight = _weightHistory.first['weight'];
              } else {
                _initialWeight = _currentWeightKg;
              }

              await _firestore.collection('user_master').doc(_userId).update({
                'physicalAttributes.initialWeight': _initialWeight,
              });
            }
          } else {
            _initialWeight = _currentWeightKg;
            _weightHistory = [
              {
                'weight': _currentWeightKg,
                'date': formatDate(DateTime.now()),
              }
            ];

            await _firestore.collection('user_master').doc(_userId).update({
              'physicalAttributes.initialWeight': _initialWeight,
              'physicalAttributes.weightHistory': _weightHistory.map((entry) => {
                'weight': entry['weight'],
                'date': entry['date'],
              }).toList(),
            });
          }

          print('Current Weight Kg: $_currentWeightKg');
          print('Target Weight Kg: $_targetWeightKg');
          print('Initial Weight Kg: $_initialWeight');
          print('Weight History: $_weightHistory');
          print('Goal: $_goal');
        } else {
          print('Physical attributes data is missing.');
        }
      } else {
        print('No data found for the user.');
      }
    } catch (e) {
      print('Failed to fetch weight data: $e');
    }
    notifyListeners();
  }

  Future<void> updateWeight(double newWeight) async {
    try {
      if (_userId != null) {
        _currentWeightKg = double.parse(newWeight.toStringAsFixed(2));
        _weightHistory.add({
          'weight': _currentWeightKg,
          'date': formatDate(DateTime.now()), // Using the utility function here
        });

        await _firestore.collection('user_master').doc(_userId).update({
          'physicalAttributes.weightKg': _currentWeightKg,
          'physicalAttributes.weightHistory': _weightHistory.map((entry) => {
            'weight': entry['weight'],
            'date': entry['date'],
          }).toList(),
        });

        print('Weight updated: $newWeight');
      } else {
        print('No user ID available for updating weight.');
      }
    } catch (e) {
      print('Failed to update weight: $e');
    }
    notifyListeners();
  }

  void updateWeights(double current, double target) {
    _currentWeightKg = double.parse(current.toStringAsFixed(2));
    _targetWeightKg = double.parse(target.toStringAsFixed(2));
    notifyListeners();
  }
}
