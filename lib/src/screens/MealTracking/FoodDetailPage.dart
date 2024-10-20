import 'package:flutter/material.dart';
import '../../../utils/date_utils.dart';
import '../../constants/color_constants.dart';
import '../../constants/path_constants.dart';

class FoodDetailPage extends StatefulWidget {
  final Map<String, dynamic> food;

  FoodDetailPage({required this.food});

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  late List<dynamic> altMeasures;
  late double selectedServingWeight;
  late String selectedMeasure;
  int selectedQuantity = 1;
  late List<double> nutrientValues;

  List<String> imagePaths = [
    PathConstants.carb,
    PathConstants.egg,
    PathConstants.fat,
    PathConstants.fiber,
  ];


  @override
  void initState() {
    super.initState();
    altMeasures = List<Map<String, dynamic>>.from(widget.food['alt_measures'] ?? []);

    // Ensure unique measures and select a default if necessary
    final uniqueMeasures = <String>{};
    altMeasures = altMeasures.where((measure) {
      final isUnique = uniqueMeasures.add(measure['measure']);
      return isUnique;
    }).toList();

    if (altMeasures.isNotEmpty) {
      selectedMeasure = altMeasures[0]['measure'];
      selectedServingWeight = altMeasures[0]['serving_weight'].toDouble();
    } else {
      selectedMeasure = 'Unknown';
      selectedServingWeight = widget.food['serving_weight_grams']?.toDouble() ?? 0;
    }

    _calculateNutrientValues();
  }


  // Function to recalculate calories based on the selected serving weight and quantity
  double _calculateCalories(
      double servingWeight, double caloriesPerGram, int quantity) {
    return caloriesPerGram * servingWeight * quantity;
  }

  // Function to calculate nutrient values based on selected measure and quantity
  void _calculateNutrientValues() {
    double multiplier = (selectedServingWeight * selectedQuantity) /
        (widget.food['serving_weight_grams']?.toDouble() ?? 1);

    // Update nutrient values based on the multiplier
    nutrientValues = [
      (widget.food['nf_total_carbohydrate']?.toDouble() ?? 0.0) * multiplier,
      (widget.food['nf_protein']?.toDouble() ?? 0.0) * multiplier,
      (widget.food['nf_total_fat']?.toDouble() ?? 0.0) * multiplier,
      (widget.food['nf_dietary_fiber']?.toDouble() ?? 0.0) * multiplier,
    ];
  }

  late final List<Map<String, dynamic>> nutrients = [
    {
      'label': 'Saturated Fat',
      'value': widget.food['nf_saturated_fat']?.toDouble() ?? 0.0,
      'unit': 'g'
    },
    {
      'label': 'Cholesterol',
      'value': widget.food['nf_cholesterol']?.toDouble() ?? 0.0,
      'unit': 'mg'
    },
    {
      'label': 'Sodium',
      'value': widget.food['nf_sodium']?.toDouble() ?? 0.0,
      'unit': 'mg'
    },
    {
      'label': 'Sugars',
      'value': widget.food['nf_sugars']?.toDouble() ?? 0.0,
      'unit': 'g'
    },
    {
      'label': 'Potassium',
      'value': widget.food['nf_potassium']?.toDouble() ?? 0.0,
      'unit': 'mg'
    },
    {
      'label': 'Phosphorus',
      'value': widget.food['nf_p']?.toDouble() ?? 0.0,
      'unit': 'mg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    String foodName = widget.food['food_name'] ?? 'Unknown';
    double baseCalories = widget.food['nf_calories']?.toDouble() ?? 0;
    double baseServingWeight =
        widget.food['serving_weight_grams']?.toDouble() ?? 1;
    double caloriesPerGram = baseCalories / baseServingWeight;
    String thumbUrl = widget.food['photo']?['thumb'] ?? ''; // Thumbnail URL
    final screenWidth = MediaQuery.of(context).size.width;

    List<String> labels = ['Carbs', 'Protein', 'Fat','Fiber'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          capitalizeFirstLetter(foodName),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth,
              height: 120,
              color: Colors.white,
              child: Row(
                children: [
                  thumbUrl.isNotEmpty
                      ? Container(
                          width: 130,
                          height: 120,
                          child: Image.network(
                            thumbUrl,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      : Icon(
                          Icons.food_bank,
                          size: 120,
                          color: Colors.grey[300],
                        ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        capitalizeFirstLetter(foodName),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${selectedServingWeight.toInt()} g - ${_calculateCalories(selectedServingWeight, caloriesPerGram, selectedQuantity).toInt()} cal',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Quantity:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMeasure,
                          decoration: InputDecoration(
                            labelText: 'Select Measure',
                            border: OutlineInputBorder(),
                          ),
                          items: altMeasures.map<DropdownMenuItem<String>>((measure) {
                            return DropdownMenuItem<String>(
                              value: measure['measure'],
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 150), // Set a maximum width
                                    child: Text(
                                      '${measure['measure']}',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal,

                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMeasure = newValue!;
                              selectedServingWeight = altMeasures
                                  .firstWhere(
                                      (measure) =>
                                          measure['measure'] == newValue,
                                      orElse: () => {
                                            'serving_weight': 0.0
                                          })['serving_weight']
                                  .toDouble();
                              // Recalculate nutrient values
                              _calculateNutrientValues();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 60,
                        // Reduce the width of the quantity input field
                        child: TextFormField(
                          initialValue: selectedQuantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedQuantity = int.tryParse(value) ?? 1;
                              // Recalculate nutrient values
                              _calculateNutrientValues();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Macronutrients Breakdown",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(imagePaths.length, (index) {
                      return Column(
                        children: [
                          Text(
                            labels[index], // Label above the card
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            // Adds shadow to the card for elevation effect
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4.0), // Rounded corners for the card
                            ),
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                child: Image(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(imagePaths[index]),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${nutrientValues[index].toStringAsFixed(2)} g',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Micronutrients Breakdown",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: nutrients.map((nutrient) {
                      final value = (nutrient['value'] *
                              ((selectedServingWeight * selectedQuantity) /
                                  baseServingWeight))
                          .toStringAsFixed(2);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(nutrient['label'],
                                  style: TextStyle(fontSize: 14)),
                              Text('$value ${nutrient['unit']}',
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              double baseCalories = widget.food['nf_calories']?.toDouble() ?? 0;
              double baseServingWeight = widget.food['serving_weight_grams']?.toDouble() ?? 1;
              double caloriesPerGram = baseCalories / baseServingWeight;
              double totalCalories = _calculateCalories(selectedServingWeight, caloriesPerGram, selectedQuantity);
              // Collect macronutrient values
              final macronutrients = {
              'Carbs': nutrientValues[0],
              'Protein': nutrientValues[1],
              'Fat': nutrientValues[2],
              'Fiber': nutrientValues[3],
              };

              // Collect micronutrient values
              final micronutrients = nutrients.map((nutrient) {
              return {
              'label': nutrient['label'],
              'value': (nutrient['value'] * ((selectedServingWeight * selectedQuantity) / baseServingWeight)).toStringAsFixed(2),
              'unit': nutrient['unit'],
              };
              }).toList();

              // Prepare food data to return
              final foodData = {
              'foodName': foodName,
              'quantity': '${selectedQuantity} ${selectedMeasure}',
              'calories': totalCalories.toInt(), // Ensure this is an int
              'macronutrients': macronutrients,  // Include macronutrients
              'micronutrients': micronutrients,  // Include micronutrients
              'altMeasures': altMeasures,        // Include alternative measures
              };

              print('Returning foodData from FoodDetailPage: $foodData'); // Debug print statement
              Navigator.pop(context, foodData);
            },
            child: Text(
              'Add Food',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorConstants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
