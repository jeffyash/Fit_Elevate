class BMICalculator {
  final int height; // Height in centimeters
  final double weight;

  BMICalculator({required this.height, required this.weight});

  double calculateBMI() {
    final heightInMeters = height / 100.0; // Convert height to meters
    return weight / (heightInMeters * heightInMeters); // BMI formula
  }

  static String interpret(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }
}
