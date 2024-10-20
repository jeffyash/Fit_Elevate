class DietPlanData{
  final String title;
  final String image;

  DietPlanData({required this.title,required this.image});
}

class DietPlanDetails{
  final String title;
  final String description;
  final String foodsToInclude;
  final String foodsToAvoid;
  final String dietGoal;


  DietPlanDetails( {
    required this.title,
    required this.description,
    required this.foodsToInclude,
    required this.foodsToAvoid,
    required this.dietGoal,
  });
}

class FoodItems{
  final String foodTitle;
  final String foodImage;

  FoodItems({required this.foodTitle,required this.foodImage});
}