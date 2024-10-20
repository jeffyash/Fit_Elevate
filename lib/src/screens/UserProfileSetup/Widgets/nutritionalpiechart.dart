import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionChart extends StatelessWidget {
  final double carbsGrams;
  final double proteinGrams;
  final double fatsGrams;

  const NutritionChart({super.key,
    required this.carbsGrams,
    required this.proteinGrams,
    required this.fatsGrams,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
                radius: 60,
                color: Colors.blue,
                value: carbsGrams,
                title: 'Carbs',
              ),
              PieChartSectionData(
                titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
                radius: 60,
                color: Colors.green,
                value: proteinGrams,
                title: 'Protein',
              ),
              PieChartSectionData(
                titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
                radius: 60,
                color: Colors.red,
                value: fatsGrams,
                title: 'Fats',
              ),
            ],
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }
}
