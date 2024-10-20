
class BMRCalculator {
  final String gender;
  final int age;
  final int heightCm;
  final double weightKg;
  final String activityLevel;

  BMRCalculator({
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
  });

  static double calculateBMR(String gender, double weightKg, int heightCm, int age) {
    if (gender.toLowerCase() == 'male') {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }


  double calculateDailyCalorieBurn() {
    double bmr = calculateBMR(gender, weightKg, heightCm, age);
    double TDEE;

    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        TDEE = bmr * 1.2;
        break;
      case 'lightly active':
        TDEE = bmr * 1.375;
        break;
      case 'moderately active':
        TDEE = bmr * 1.55;
        break;
      case 'very active':
        TDEE = bmr * 1.725;
        break;
      case 'super active':
        TDEE = bmr * 1.9;
        break;
      default:
        TDEE = bmr * 1.2; // Default to sedentary if activity level is not set
        break;
    }
    return TDEE;
  }
}


