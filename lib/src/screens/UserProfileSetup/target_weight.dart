import 'package:fitelevate/src/screens/UserProfileSetup/userinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../constants/text_constants.dart';
import '../../models/RulerPainter.dart';

class TargetWeight extends StatelessWidget {
  const TargetWeight({super.key});

  @override
  Widget build(BuildContext context) {
    final userTarWeight = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                TextConstants.targetwt_title,
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  TextConstants.targetwt_subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
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
                        userTarWeight.isTarKg = true;
                        userTarWeight.updateTargetWeight();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: userTarWeight.isKg ? Colors.white : Colors.white,
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
                              color: userTarWeight.isTarKg
                                  ? Colors.purple
                                  : Colors.black,
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
                        userTarWeight.isTarKg = false;
                        userTarWeight.updateTargetWeight();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            TextConstants.lbs,
                            style: TextStyle(
                              fontSize: 20,
                              color: userTarWeight.isTarKg
                                  ? Colors.black
                                  : Colors.purple,
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
              userTarWeight.isTarKg
                  ? "${userTarWeight.targetWeightKg.toStringAsFixed(1)} kg"
                  : "${userTarWeight.targetWeightLbs.toStringAsFixed(1)} lbs",
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
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
                            userTarWeight.isTarKg
                                ?  DecimalNumberPicker(
                              value: userTarWeight.targetWeightKg,
                              minValue: 30,
                              maxValue: 200,
                              decimalPlaces: 1,
                              onChanged: (value) {
                                userTarWeight.targetWeightKg = value;
                                userTarWeight.updateTargetWeight();
                              },
                              axis: Axis.horizontal,
                              itemHeight: 65,
                              itemWidth: 45,
                              itemCount: 3,
                              textStyle: const TextStyle(fontSize: 20),
                              selectedTextStyle: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                :  DecimalNumberPicker(
                              minValue: 60,
                              maxValue: 440,
                              decimalPlaces: 1,
                              value: userTarWeight.targetWeightLbs,
                              onChanged: (value) {
                                userTarWeight.targetWeightLbs = value;
                                userTarWeight.updateTargetWeight();
                              },
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
