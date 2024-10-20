import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../../constants/text_constants.dart';
import '../../models/RulerPainter.dart';
import 'userinfo_provider.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userWeight = Provider.of<UserInfoProvider>(context);

    void _updateWeight(double value) {
      if (userWeight.isKg) {
        userWeight.weightKg = value;
      } else {
        userWeight.weightLbs = value;
      }
      userWeight.updateWeight();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              TextConstants.weight_title,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 10),
            const Text(
              TextConstants.weight_subtitle,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        userWeight.isKg = true;
                        userWeight.updateWeight();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: userWeight.isKg ? Colors.white : Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            TextConstants.kg,
                            style: TextStyle(
                              fontSize: 20,
                              color: userWeight.isKg ? Colors.purple : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        userWeight.isKg = false;
                        userWeight.updateWeight();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !userWeight.isKg ? Colors.white : Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            TextConstants.lbs,
                            style: TextStyle(
                              fontSize: 20,
                              color: !userWeight.isKg ? Colors.purple : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              userWeight.isKg
                  ? "${userWeight.weightKg.toStringAsFixed(1)} kg"
                  : "${userWeight.weightLbs.toStringAsFixed(1)} lbs",
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 200,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Stack(
                  children: [
                    Positioned.fill(
                      left: 10,
                      bottom: 45,
                      top: 5,
                      child: CustomPaint(
                        painter: RulerPainterFunction(),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 5,
                      child: Center(
                        child: Column(
                          children: [
                            userWeight.isKg
                                ? DecimalNumberPicker(
                              value: userWeight.weightKg,
                              minValue: 30,
                              maxValue: 200,
                              decimalPlaces: 1,
                              onChanged: _updateWeight,
                              axis: Axis.horizontal,
                              itemHeight: 65,
                              itemWidth: 45,
                              itemCount: 3,
                              textStyle: const TextStyle(fontSize: 20),
                              selectedTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : DecimalNumberPicker(
                              minValue: 60,
                              maxValue: 440,
                              decimalPlaces: 1,
                              value: userWeight.weightLbs,
                              onChanged: _updateWeight,
                              axis: Axis.vertical,
                              itemHeight: 65,
                              itemWidth: 45,
                              itemCount: 3,
                              textStyle: const TextStyle(fontSize: 20),
                              selectedTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 55,
                      top: 0,
                      bottom: 25,
                      child: Center(
                        child: Icon(
                          Icons.arrow_right,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
