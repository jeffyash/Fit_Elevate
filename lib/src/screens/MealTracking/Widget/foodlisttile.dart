import 'package:flutter/material.dart';
import 'package:fitelevate/src/constants/color_constants.dart';
class FoodListTile extends StatelessWidget {
  final String foodName;
  final String quantity;
  final String calories;
  final String mealType;
  final VoidCallback onDelete; // Callback for delete action


  FoodListTile({
    required this.foodName,
    required this.quantity,
    required this.calories,
    required this.mealType,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: ColorConstants.containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(foodName.isNotEmpty ? foodName : 'No Name'),
          Text('$calories cal'),
        ],
      ),
      subtitle: Text(quantity.isNotEmpty ? quantity : 'No Quantity'),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Delete"),
            onTap: onDelete
          ),
        ],
      ),
    );
  }
}


