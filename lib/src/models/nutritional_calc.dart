class NutritionCalculations {
  // Method to calculate protein, fat, and carb grams
  static Map<String, double> calculateNutrients(double dailyCalorieIntake, {bool lowCarb = false}) {
    var proteinPercentage = 0.25; // 25% of total calories
    var fatPercentage = 0.30; // 30% of total calories
    var carbPercentage = 0.45; // 45% of total calories

    if (lowCarb) {
      // Adjust the percentages for a low carb diet
      proteinPercentage = 0.30; // 30% of total calories
      fatPercentage = 0.45; // 45% of total calories
      carbPercentage = 0.25; // 25% of total calories
    }

    final proteinCalories = dailyCalorieIntake * proteinPercentage;
    final fatCalories = dailyCalorieIntake * fatPercentage;
    final carbCalories = dailyCalorieIntake * carbPercentage;

    final proteinGrams = proteinCalories / 4;
    final fatGrams = fatCalories / 9;
    final carbGrams = carbCalories / 4;


    return {
      'proteinGrams': proteinGrams,
      'fatGrams': fatGrams,
      'carbGrams': carbGrams,
      'proteinPercentage': proteinPercentage,
      'fatPercentage': fatPercentage,
      'carbPercentage': carbPercentage,
    };
  }
  // Method to convert daily calorie intake to int
  static int convertDailyCalorieToInt(double dailyCalorieIntake) {
    return dailyCalorieIntake.toInt();
  }
  }

