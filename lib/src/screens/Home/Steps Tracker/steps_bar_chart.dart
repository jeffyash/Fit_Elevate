import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'steps_daily_track_provider.dart';

class StepsTrackingChart extends StatefulWidget {
  @override
  _StepsTrackingChartState createState() => _StepsTrackingChartState();
}

class _StepsTrackingChartState extends State<StepsTrackingChart> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stepsProvider = Provider.of<StepsDailyTrackingProvider>(context, listen: false);
      stepsProvider.initialize();
      _setInitialPage();
    });
  }

  void _setInitialPage() {
    final stepsProvider = Provider.of<StepsDailyTrackingProvider>(context, listen: false);

    final stepsData = stepsProvider.stepsWalkedData;
    final sortedDates = stepsData.keys.toList()..sort();

    final today = DateTime.now();
    final todayIndex = sortedDates.indexWhere((date) =>
    date.year == today.year && date.month == today.month && date.day == today.day);

    int pageIndex = todayIndex >= 0 ? (todayIndex / 7).floor() : (sortedDates.length / 7).floor();
    pageIndex = pageIndex < 0 ? 0 : pageIndex;
    _pageController.jumpToPage(pageIndex);
  }

  String _getDateRangeForPage(List<DateTime> sortedDates, int pageIndex) {
    final start = pageIndex * 7;
    final end = (start + 7 < sortedDates.length) ? start + 7 : sortedDates.length;

    if (sortedDates.isEmpty || start >= sortedDates.length || end > sortedDates.length) {
      return 'No data available';
    }

    final firstDate = sortedDates[start];
    final lastDate = sortedDates[end - 1];

    return '${DateFormat('dd MMM').format(firstDate)} - ${DateFormat('dd MMM').format(lastDate)}';
  }

  @override
  Widget build(BuildContext context) {
    final stepsProvider = Provider.of<StepsDailyTrackingProvider>(context);
    final stepsData = stepsProvider.stepsWalkedData;
    final dailyStepGoal = stepsProvider.dailyStepGoal;
    final sortedDates = stepsData.keys.toList()..sort();

    return Container(
      height: 500,
      padding: const EdgeInsets.all(8.0),
      child: stepsData.isEmpty
          ? Center(child: Text('No data available', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : Column(
        children: [
          if (sortedDates.isNotEmpty)
            Text(
              _getDateRangeForPage(sortedDates, _currentPageIndex),
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: (sortedDates.length / 7).ceil(),
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * 7;
                final end = (start + 7 < sortedDates.length) ? start + 7 : sortedDates.length;

                if (start >= sortedDates.length || sortedDates.isEmpty) {
                  return Center(child: Text('No data for this week'));
                }

                final visibleDates = sortedDates.sublist(start, end);

                return Stack(
                  children: [
                    Container(
                      height: 500,
                      color: ColorConstants.bodyColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.start,
                            maxY: dailyStepGoal.toDouble(),
                            minY: 0,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: value == 0 ? Colors.black : Colors.grey,
                                strokeWidth: value == 0 ? 1 : 0,
                              ),
                              getDrawingVerticalLine: (value) => FlLine(
                                color: value == 0 ? Colors.black : Colors.transparent,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 80,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < visibleDates.length) {
                                      final date = visibleDates[index];
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(height: 1, width: 50, color: Colors.grey),
                                          SizedBox(height: 4),
                                          Text(DateFormat('d').format(date), style: TextStyle(fontSize: 12)),
                                          Text(DateFormat('EEE').format(date), style: TextStyle(fontSize: 12)),
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                  getTitlesWidget: (value, meta) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        value.toInt().toString(),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: visibleDates.asMap().entries.map((entry) {
                              final index = entry.key;
                              final date = entry.value;
                              final steps = stepsData[date] ?? 0;

                              return BarChartGroupData(
                                x: index,
                                barsSpace: 15.0,
                                barRods: [
                                  BarChartRodData(
                                    toY: steps.toDouble(),
                                    color: Colors.blue,
                                    width: 30.0,
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
