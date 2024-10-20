class UserFitnessProfile {
  String gender;
  int age;
  double weightKg;
  double weightLbs;
  int heightCm;
  int heightFt;
  int heightInch;
  List<String> dietPreferences;
  String activityLevel;
  String goal;
  double targetWeightKg;
  double targetWeightLbs;
  String selectedCalorieGoal;

  UserFitnessProfile({
    required this.gender,
    required this.age,
    required this.weightKg,
    required this.weightLbs,
    required this.heightCm,
    required this.heightFt,
    required this.heightInch,
    required this.dietPreferences,
    required this.activityLevel,
    required this.goal,
    required this.targetWeightKg,
    required this.targetWeightLbs,
    required this.selectedCalorieGoal,
  });

  // Method to convert the model to a map (e.g., for saving to a database)
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'age': age,
      'weightKg': weightKg,
      'weightLbs': weightLbs,
      'heightCm': heightCm,
      'heightFt': heightFt,
      'heightInch': heightInch,
      'dietPreferences': dietPreferences,
      'activityLevel': activityLevel,
      'goal': goal,
      'targetWeightKg': targetWeightKg,
      'targetWeightLbs': targetWeightLbs,
      'selectedCalorieGoal': selectedCalorieGoal,
    };
  }

  // Method to create a UserData object from a map (e.g., for retrieving from a database)
  factory UserFitnessProfile.fromMap(Map<String, dynamic> map) {
    return UserFitnessProfile(
      gender: map['gender'] ?? '',
      age: map['age'] ?? 0,
      weightKg: map['weightKg'] ?? 0.0,
      weightLbs: map['weightLbs'] ?? 0.0,
      heightCm: map['heightCm'] ?? 0,
      heightFt: map['heightFt'] ?? 0,
      heightInch: map['heightInch'] ?? 0,
      dietPreferences: List<String>.from(map['dietPreferences'] ?? []),
      activityLevel: map['activityLevel'] ?? '',
      goal: map['goal'] ?? '',
      targetWeightKg: map['targetWeightKg'] ?? 0.0,
      targetWeightLbs: map['targetWeightLbs'] ?? 0.0,
      selectedCalorieGoal: map['selectedCalorieGoal'] ?? '',
    );
  }
}
