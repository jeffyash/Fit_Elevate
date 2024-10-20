import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/screens/Home/WeightTracker/weight_data_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/date_utils.dart';

class WeightProgressChart extends StatelessWidget {
  final List<Map<String, dynamic>> weightHistory;
  final String Function(DateTime) formatDate;

  const WeightProgressChart({
    Key? key,
    required this.weightHistory,
    required this.formatDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weightProvider = Provider.of<WeightTrackerProvider>(context);
    final weightGoal = Provider.of<WeightTrackerProvider>(context);
    String goal = weightGoal.goal;
    double targetWeight = weightProvider.targetWeightKg;
    double initialWeight = weightProvider.initialWeight;

    // Prepare data for the chart
    List<FlSpot> spots = [];
    List<String> dates = [];

    for (int i = 0; i < weightHistory.length; i++) {
      double weight = weightHistory[i]['weight'];
      String dateStr = weightHistory[i]['date'];

      try {
        // Parse the date string to a DateTime object using the utility function
        DateTime date = parseDate(dateStr);
        String formattedDate = DateFormat('dd\nMMM').format(date);

        // Add data to the chart
        spots.add(FlSpot(i.toDouble(), weight));
        dates.add(formattedDate);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    // Initialize minY and maxY with default values
    double minY = initialWeight - 6; // Default initialization, more buffer
    double maxY = targetWeight + 4;   // Default initialization

    // Adjust minY and maxY based on the user's goal and historical data
    if (goal == 'weight gain') {
      minY = initialWeight - 5; // For weight gain, set minY below the initial weight
    } else if (goal == 'weight loss') {
      minY = targetWeight - 5; // For weight loss, set minY slightly below target weight
    } else if (goal == 'maintenance') {
      minY = initialWeight - 5; // For maintenance, set minY below initial weight
    } else if (goal == 'muscle gain') {
      minY = initialWeight - 5; // For muscle gain, set minY below initial weight
    }

    // Ensure maxY is based on the highest recorded weight or the target weight
    if (spots.isNotEmpty) {
      double highestWeight = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
      maxY = highestWeight + 4; // Buffer above the highest weight
    } else {
      maxY = targetWeight + 4; // Buffer above target weight
    }

// Ensure maxY is at least the target weight to avoid it being out of view
    if (maxY < targetWeight + 4) {
      maxY = targetWeight + 4; // Ensure that maxY accommodates the target weight
    }


    // Ensure minY is less than maxY for a proper range
    if (minY >= maxY) {
      minY = maxY - 5; // Provide at least a 5-unit range if they're too close
    }

    // Define the interval for the Y-axis labels
    double interval = 2; // Interval between Y-axis labels
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (spots.isNotEmpty) ? (spots.length * 165).toDouble() : 300,
            height: 460,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < dates.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              dates[index],
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(''),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,

                      getTitlesWidget: (value, meta) {
                        final intValue = value.toInt();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            intValue.toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      interval: interval,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,  // Enable the border
                  border: Border.all(
                    color: Colors.transparent,  // Color of the border
                    width: 6,            // Width of the border
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 3,
                    color: ColorConstants.primaryColor,
                    belowBarData: BarAreaData(
                      show: true,
                      color: ColorConstants.primaryColor.withOpacity(0.3),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: ColorConstants.primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                    showingIndicators: List.generate(spots.length, (index) => index),
                  ),
                  LineChartBarData(
                    spots: [
                      FlSpot(0, targetWeight),
                      FlSpot(spots.length.toDouble() + 14, targetWeight),
                    ],
                    isCurved: false,
                    barWidth: 2,
                    color: Colors.red,
                    dotData: FlDotData(show: false),
                    dashArray: [6, 3],
                  ),
                ],
                minX: 0,
                maxX: (spots.isNotEmpty) ? (spots.length + 5).toDouble() : 0,
                minY: minY,
                maxY: maxY,
                extraLinesData: ExtraLinesData(horizontalLines: [
                  HorizontalLine(
                    y: targetWeight,
                    color: Colors.red,
                    strokeWidth: 2,
                    dashArray: [6, 3],
                  ),
                ]),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (group) => Colors.transparent,
                    getTooltipItems: (spots) => spots.map((spot) {
                      return LineTooltipItem(
                        spot.y.toStringAsFixed(1),
                        TextStyle(
                          color: ColorConstants.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Positioned values above each spot

        // ...spots.asMap().entries.map((entry) {
        //   final index = entry.key;
        //   final spot = entry.value;
        //
        //   // Adjust left and top positioning based on the spot's position
        //   return Positioned(
        //     left: index * 60.0 + 33,  // Adjust left based on chart's width per spot
        //     top: 300 - ((spot.y - minY) / (maxY - minY)) * 250 - 70  ,// Adjust top based on y-value
        //     child: SingleChildScrollView(
        //       child: Text(
        //         spot.y.toStringAsFixed(1),
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontSize: 14,
        //           fontWeight: FontWeight.normal,
        //         ),
        //       ),
        //     ),
        //   );
        // }).toList(),
      ],
    );
  }
}
