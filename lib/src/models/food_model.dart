class Food {
  final String name;
  final String quantity;
  final int calories;

  Food({
    required this.name,
    required this.quantity,
    required this.calories,
  });

  // Convert a Food instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'calories': calories,
    };
  }

  // Convert a map to a Food instance
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'],
      quantity: map['quantity'],
      calories: map['calories'],
    );
  }
}

