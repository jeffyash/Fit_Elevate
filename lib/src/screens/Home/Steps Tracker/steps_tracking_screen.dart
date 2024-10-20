import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'steps_bar_chart.dart';
import 'steps_calendar_widget.dart';
import 'steps_daily_track_provider.dart';
import 'steps_widget.dart';

class StepTrackingScreen extends StatefulWidget {
  @override
  _StepTrackingScreenState createState() => _StepTrackingScreenState();
}

class _StepTrackingScreenState extends State<StepTrackingScreen> {
  bool _isCalendarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<StepsDailyTrackingProvider>(
        builder: (context, stepCountProvider, child)
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
                  stepCountProvider.getDateTitle(stepCountProvider.selectedDate),
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
          actions: [
            IconButton(
              onPressed: () => _showGoalDialog(context, stepCountProvider),
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(children: [
            Column(
              children: [
                StepCountProgress(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Daily Step Count',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 16),
                      StepsTrackingChart(),
                    ],
                  ),
                ),
                // Use the new BarChart widget
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
                  child: StepsCalendarWidget(), // The calendar widget
                ),
              ),
          ]
          ),
        ),
      );
    }
    );
  }
  void _showGoalDialog(BuildContext context, StepsDailyTrackingProvider provider) {
    final TextEditingController _controller =
    TextEditingController(text: provider.dailyStepGoal.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Daily Step Goal'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Daily Goal',
              hintText: 'Enter your daily step goal',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Set Goal'),
              onPressed: () {
                final int? newGoal = int.tryParse(_controller.text);
                if (newGoal != null && newGoal > 0) {
                  provider.setStepGoal(newGoal);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
