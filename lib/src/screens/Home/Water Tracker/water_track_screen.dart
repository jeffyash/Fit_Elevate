import 'package:fitelevate/src/screens/Home/Water Tracker/water_tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import 'water_calendar_widget.dart';
import 'water_intake_chart.dart';

class WaterTrackingPage extends StatefulWidget {
  final int dailyWaterIntake;

  WaterTrackingPage({required this.dailyWaterIntake});

  @override
  _WaterTrackingPageState createState() => _WaterTrackingPageState();
}

class _WaterTrackingPageState extends State<WaterTrackingPage> {
  bool _isCalendarVisible = false;
  final int _mlPerGlass = 250;
  List<DateTime> sortedDates = [];

  @override
  void initState() {
    super.initState();
    _generateLast7Days(); // Generate the last 7 days
  }

  void _generateLast7Days() {
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = today.subtract(Duration(days: i));
      sortedDates.add(day);
    }
    sortedDates = sortedDates.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Container(
            color: Colors.white,
          ),
        ),
        title: GestureDetector(
          onTap: () {
            setState(() {
              _isCalendarVisible = !_isCalendarVisible;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<WaterIntakeProvider>(
                builder: (context, userWaterProvider, child) {
                  return Text(
                    userWaterProvider.getDateTitle(),
                    style: const TextStyle(fontSize: 20),
                  );
                },
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
      body: Stack(
        children: [
          // Main body content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<WaterIntakeProvider>(
                  builder: (context, userWaterProvider, child) {
                    final totalWaterConsumed = userWaterProvider.totalWaterConsumed;
                    double progress = totalWaterConsumed / widget.dailyWaterIntake;
                    return Column(
                      children: [
                        Text(
                          '${(totalWaterConsumed / _mlPerGlass).round()} / ${(widget.dailyWaterIntake / _mlPerGlass).round()} Glasses',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          color: ColorConstants.water,
                          backgroundColor: Colors.blue.withOpacity(0.3),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 36),
                              onPressed: () {
                                if (totalWaterConsumed >= _mlPerGlass) {
                                  userWaterProvider.removeWater(_mlPerGlass);
                                }
                              },
                            ),
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.water,
                                border: Border.all(
                                  color: ColorConstants.water,
                                  width: 2.0,
                                ),
                              ),
                              child: LiquidCircularProgressIndicator(
                                value: progress,
                                valueColor: AlwaysStoppedAnimation(ColorConstants.water),
                                backgroundColor: Colors.white,
                                borderColor: ColorConstants.water,
                                borderWidth: 1.0,
                                direction: Axis.vertical,
                                center: Text(
                                  '${(progress * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.textBlack,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 36),
                              onPressed: () {
                                if (totalWaterConsumed + _mlPerGlass <= widget.dailyWaterIntake){
                                  userWaterProvider.addWater(_mlPerGlass);
                                }
                              },
                            ),
                          ],
                        ),
                        Text(
                          'Water Consumed: ${totalWaterConsumed} ml',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Your Daily Goal: ${(widget.dailyWaterIntake / 1000).round()} L',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.textBlack,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                Expanded(child: WaterIntakeChart()),
              ],
            ),
          ),
          // Black overlay with opacity
          if (_isCalendarVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isCalendarVisible = false;
                  });
                },
                child: Container(
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
                child: CalendarWidget(), // The calendar widget
              ),
            ),
        ],
      ),
    );
  }
}
