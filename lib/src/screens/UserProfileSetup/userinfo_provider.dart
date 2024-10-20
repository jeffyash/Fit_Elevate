import 'package:flutter/material.dart';
import '../../constants/text_constants.dart';
import '../../models/BMI_model.dart';
import '../../models/BMR_model.dart';
import '../../models/user_fitness_model.dart';

class UserInfoProvider with ChangeNotifier {
  // User Info
  String _gender = 'Not Specified'; // Default
  int _age = 18; // Default
  int _heightCm = 160; // Default
  int _heightFt = 5; // Default
  int _heightInch = 1; // Default
  bool _isCm = true; // Default

  double _weightKg = 58.0; // Default
  double _weightLbs = 128.0; // Default
  bool _isKg = true; // Default
  bool _isTarKg = true; // Default
  List<String> _dietPreferences = []; // Default
  String _activityLevel = 'Not Specified'; // Default
  String _goal = 'Not Specified'; // Default
  double _targetWeightKg = 58.0; // Default
  double _targetWeightLbs = 128.0; // Default

  // CalorieGoal
  String _selectedCalorieGoal = 'Not Specified'; // Default

  // Weight History
  List<Map<String, dynamic>> _weightHistory = []; // Default

  // Getters and Setters
  // User Info
  String get gender => _gender;

  int get age => _age;

  int get heightCm => _heightCm;

  int get heightFt => _heightFt;

  int get heightInch => _heightInch;

  bool get isCm => _isCm;

  double get weightKg => _weightKg;

  double get weightLbs => _weightLbs;

  bool get isKg => _isKg;

  bool get isTarKg => _isTarKg;

  List<String> get dietPreferences => _dietPreferences;

  String get activityLevel => _activityLevel;

  String get goal => _goal;

  double get targetWeightKg => _targetWeightKg;

  double get targetWeightLbs => _targetWeightLbs;

  String get selectedCalorieGoal => _selectedCalorieGoal;

  List<Map<String, dynamic>> get weightHistory => _weightHistory;

  // Setters
  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  set age(int value) {
    _age = value;
    notifyListeners();
  }

  set heightCm(int value) {
    _heightCm = value;
    updateHeight();
    notifyListeners();
  }

  set heightFt(int value) {
    _heightFt = value;
    updateHeight();
    notifyListeners();
  }

  set heightInch(int value) {
    _heightInch = value;
    updateHeight();
    notifyListeners();
  }

  set isCm(bool value) {
    if (_isCm != value) {
      _isCm = value;
      updateHeight();
      notifyListeners();
    }
  }

  set weightKg(double value) {
    _weightKg = value;
    updateWeight();
    notifyListeners();
  }

  set weightLbs(double value) {
    _weightLbs = value;
    updateWeight();
    notifyListeners();
  }

  set isKg(bool value) {
    if (_isKg != value) {
      _isKg = value;
      if (value) {
        _weightKg = convertLbsToKg(_weightLbs);
      } else {
        _weightLbs = convertKgToLbs(_weightKg);
      }
      notifyListeners();
    }
  }

  set isTarKg(bool value) {
    if (_isTarKg != value) {
      _isTarKg = value;
      if (value) {
        _targetWeightKg = convertLbsToKg(_targetWeightLbs);
      } else {
        _targetWeightLbs = convertKgToLbs(_targetWeightKg);
      }
      notifyListeners();
    }
  }

  set dietPreferences(List<String> preferences) {
    _dietPreferences = preferences;
    notifyListeners();
  }

  set activityLevel(String level) {
    _activityLevel = level;
    notifyListeners();
  }

  set goal(String value) {
    _goal = value;
    notifyListeners();
  }

  set targetWeightKg(double value) {
    _targetWeightKg = value;
    notifyListeners();
  }

  set targetWeightLbs(double value) {
    _targetWeightLbs = value;
    notifyListeners();
  }

  set selectedCalorieGoal(String value) {
    _selectedCalorieGoal = value;
    notifyListeners();
  }

  // Conversion Methods
  double _convertCmToFt(int cm) {
    return cm / 30.48;
  }

  double _convertCmToInch(int cm) {
    return (cm / 2.54) % 12;
  }

  int convertFtInchToCm(int ft, int inch) {
    return ((ft * 12 + inch) * 2.54).toInt();
  }

  double convertKgToLbs(double kg) {
    return double.parse((kg * 2.20462).toStringAsFixed(2));
  }

  double convertLbsToKg(double lbs) {
    return double.parse((lbs / 2.20462).toStringAsFixed(2));
  }
  // Methods to reset to default values
  void resetToDefaults() {
    _gender = 'Not Specified';
    _age = 18;
    _heightCm = 160;
    _heightFt = 5;
    _heightInch = 1;
    _isCm = true;
    _weightKg = 58;
    _weightLbs = 128;
    _isKg = true;
    _isTarKg = true;
    _dietPreferences = [];
    _activityLevel = 'Not Specified';
    _goal = 'Not Specified';
    _targetWeightKg = 58;
    _targetWeightLbs = 128;
    _selectedCalorieGoal = 'Not Specified';
    _weightHistory = [];

    notifyListeners();
  }

  void updateHeight() {
    if (_isCm) {
      _heightFt = _convertCmToFt(_heightCm).toInt();
      _heightInch = _convertCmToInch(_heightCm).toInt();
    } else {
      _heightCm = convertFtInchToCm(_heightFt, _heightInch).toInt();
    }
    notifyListeners();
  }

  void updateWeight() {
    if (_isKg) {
      _weightLbs = convertKgToLbs(_weightKg);
    } else {
      _weightKg = convertLbsToKg(_weightLbs);
    }
    notifyListeners();
  }

  void updateTargetWeight() {
    if (_isTarKg) {
      _targetWeightLbs = convertKgToLbs(_targetWeightKg);
    } else {
      _targetWeightKg = convertLbsToKg(_targetWeightLbs);
    }
    notifyListeners();
  }

  // BMI Calculation

  double calculateBMI() {
    final bmiCalculator = BMICalculator(height: _heightCm, weight: _weightKg);
    final bmiValue = bmiCalculator.calculateBMI();
    return bmiValue;
  }

  String get bmiStatus {
    double bmi = calculateBMI();
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  String getBMIInterpretation(double bmi) {
    return BMICalculator.interpret(bmi);
  }

  // BMR calculation
  // Calculate BMR
  double calculateBMR() {
    return BMRCalculator.calculateBMR(
        gender, weightKg, heightCm, age);
  }

  double calculateDailyCalorieBurn() {
    final bmrCalculator = BMRCalculator(
      gender: _gender,
      age: _age,
      heightCm: _heightCm,
      weightKg: _weightKg,
      activityLevel: _activityLevel,
    );
    return bmrCalculator.calculateDailyCalorieBurn();
  }

  double calculateDailyCalorieGoalForWeightLoss(String weightLossGoal) {
    double dailyCalorieBurn = calculateDailyCalorieBurn();
    double dailyCalorieGoal;

    // Determine the daily weight loss goal based on the input
    switch (weightLossGoal) {
      case TextConstants.loseTitle1:
        dailyCalorieGoal = dailyCalorieBurn - 250;
        break;
      case TextConstants.loseTitle2:
        dailyCalorieGoal = dailyCalorieBurn - 500;
        break;
      case TextConstants.loseTitle3:
        dailyCalorieGoal = dailyCalorieBurn - 750;
        break;
      case TextConstants.loseTitle4:
        dailyCalorieGoal = dailyCalorieBurn - 1000;
        break;
      default:
        dailyCalorieGoal = dailyCalorieBurn; // No adjustment if goal is not set
        break;
    }
    return dailyCalorieGoal;
  }

  double calculateDailyCalorieGoalForWeightGain(String weightGainGoal) {
    double dailyCalorieBurn = calculateDailyCalorieBurn();
    double dailyCalorieGoal;

    // Determine the daily weight gain goal based on the input
    switch (weightGainGoal) {
      case TextConstants.gainTitle1:
        dailyCalorieGoal = dailyCalorieBurn + 250;
        break;
      case TextConstants.gainTitle2:
        dailyCalorieGoal = dailyCalorieBurn + 500;
        break;
      case TextConstants.gainTitle3:
        dailyCalorieGoal = dailyCalorieBurn + 750;
        break;
      case TextConstants.gainTitle4:
        dailyCalorieGoal = dailyCalorieBurn + 1000;
        break;
      default:
        dailyCalorieGoal = dailyCalorieBurn; // No adjustment if goal is not set
    }
    return dailyCalorieGoal;
  }

  double calculateAdjustedCaloriesForWeightMaintain() {
    return calculateDailyCalorieBurn(); // No adjustment needed
  }

  double calculateAdjustedCaloriesForMuscleGain(String muscleGainGoal) {
    double dailyCalorieBurn = calculateDailyCalorieBurn();
    double dailyCalorieGoal;

    // Determine the daily muscle gain goal based on the input
    switch (muscleGainGoal) {
      case TextConstants.muscleGainTitle1:
        dailyCalorieGoal = dailyCalorieBurn + 250;
        break;
      case TextConstants.muscleGainTitle2:
        dailyCalorieGoal = dailyCalorieBurn + 500;
        break;
      default:
        dailyCalorieGoal = dailyCalorieBurn; // No adjustment if goal is not set
    }
    return dailyCalorieGoal;
  }

  // Determine the goal and calculate accordingly
  double calculateDailyCalorieGoal(String goalTitle) {
    if (_goal == 'Weight Loss') {
      return calculateDailyCalorieGoalForWeightLoss(goalTitle);
    } else if (_goal == 'Weight Gain') {
      return calculateDailyCalorieGoalForWeightGain(goalTitle);
    } else if (_goal == 'Maintain Weight') {
      return calculateAdjustedCaloriesForWeightMaintain();
    } else if (_goal == 'Gain Muscle') {
      return calculateAdjustedCaloriesForMuscleGain(goalTitle);
    } else {
      return calculateDailyCalorieBurn(); // Default to maintenance calories
    }
  }




  Future<void> updateFitnessData({
    String? gender,
    int? age,
    int? heightCm,
    int? heightFt,
    int? heightInch,
    bool? isCm,
    int? weightKg,
    int? weightLbs,
    bool? isKg,
    bool? isTarKg,
    List<String>? dietPreferences,
    String? activityLevel,
    String? goal,
    double? targetWeightKg,
    double? targetWeightLbs,
    String? selectedCalorieGoal,
  }) async {
    if (gender != null) _gender = gender;
    if (age != null) _age = age;
    if (heightCm != null) {
      _heightCm = heightCm;
      _heightFt = _convertCmToFt(heightCm).toInt();
      _heightInch = _convertCmToInch(heightCm).toInt();
    }
    if (heightFt != null && heightInch != null) {
      _heightFt = heightFt;
      _heightInch = heightInch;
      _heightCm = convertFtInchToCm(heightFt, heightInch);
    }
    if (isCm != null) {
      _isCm = isCm;
      if (isCm) {
        _heightFt = _convertCmToFt(_heightCm).toInt();
        _heightInch = _convertCmToInch(_heightCm).toInt();
      } else {
        _heightCm = convertFtInchToCm(_heightFt, _heightInch).toInt();
      }
    }
    if (weightKg != null) {
      _weightKg = weightKg as double;
      _weightLbs = convertKgToLbs(weightKg as double);
    }
    if (weightLbs != null) {
      _weightLbs = weightLbs as double;
      _weightKg = convertLbsToKg(weightLbs as double);
    }
    if (isKg != null) {
      _isKg = isKg;
      if (isKg) {
        _weightLbs = convertKgToLbs(_weightKg);
      } else {
        _weightKg = convertLbsToKg(_weightLbs);
      }
    }
    if (isTarKg != null) {
      _isTarKg = isTarKg;
      if (isTarKg) {
        _targetWeightLbs = convertKgToLbs(_targetWeightKg);
      } else {
        _targetWeightKg = convertLbsToKg(_targetWeightLbs);
      }
    }
    if (dietPreferences != null) _dietPreferences = dietPreferences;
    if (activityLevel != null) _activityLevel = activityLevel;
    if (goal != null) _goal = goal;
    if (targetWeightKg != null) _targetWeightKg = targetWeightKg;
    if (targetWeightLbs != null) _targetWeightLbs = targetWeightLbs ;
    if (selectedCalorieGoal != null) _selectedCalorieGoal = selectedCalorieGoal;

    // Notify listeners and save updated data
    notifyListeners();
  }// Methods to get UserData
  UserFitnessProfile get userFitness {
    return UserFitnessProfile(
      gender: _gender,
      age: _age,
      weightKg: _weightKg,
      weightLbs: _weightLbs,
      heightCm: _heightCm,
      heightFt: _heightFt,
      heightInch: _heightInch,
      dietPreferences: _dietPreferences,
      activityLevel: _activityLevel,
      goal: _goal,
      targetWeightKg: _targetWeightKg,
      targetWeightLbs: _targetWeightLbs,
      selectedCalorieGoal: _selectedCalorieGoal,
    );
  }

}
