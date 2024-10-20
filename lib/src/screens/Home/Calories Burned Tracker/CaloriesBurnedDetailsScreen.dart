import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CaloriesBurnedCalendar.dart';
import 'CaloriesBurnedProvider.dart';

class CaloriesBurnedDetails extends StatefulWidget {

  const CaloriesBurnedDetails({super.key});

  @override
  State<CaloriesBurnedDetails> createState() => _CaloriesBurnedDetailsState();
}

class _CaloriesBurnedDetailsState extends State<CaloriesBurnedDetails> {
  bool _isCalendarVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<CaloriesBurnedProvider>(
        builder: (context, caloriesBurnedProvider, child)
    {
      return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              setState(() {
                _isCalendarVisible = !_isCalendarVisible;
              });
            },
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text(
                  caloriesBurnedProvider.getDateTitle(),
            style: const TextStyle(fontSize: 20),
          ),
          Icon(
            _isCalendarVisible
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down,
            size: 24,
          ),
          ],
        ),
      ),
      centerTitle: true,
      ),
        body: SingleChildScrollView(
          child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight,
                ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text('Calories Burned: ${caloriesBurnedProvider.caloriesBurned.toStringAsFixed(0)}',style: TextStyle(
                            fontSize: 18,
                          ),),
                        ],
                      ),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: caloriesBurnedProvider.progressValue,
                        minHeight: 8,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Recent Workouts",style: TextStyle(fontSize: 16),),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Display the list of workout titles
                      ...caloriesBurnedProvider.workoutTitles.map((title) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.fitness_center, size: 20),
                              SizedBox(width: 10),
                              Text(
                                title,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
            if (_isCalendarVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCalendarVisible = false;
                    });
                  },
                  child: Container(
                    height: 500,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            // Calendar overlay with white background
            if (_isCalendarVisible)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.white, // White background for the calendar
                  child: CaloriesBurnedCalendar(), // The calendar widget
                ),
              ),
          ]
          ),
        ),
      );
    }
    );
  }
}
