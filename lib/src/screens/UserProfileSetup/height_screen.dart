import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../../constants/text_constants.dart';
import '../../models/RulerPainter.dart';
import 'userinfo_provider.dart';

class HeightScreen extends StatelessWidget {
  const HeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              TextConstants.height_title,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 10),
            const Text(
              TextConstants.height_subtitle,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Consumer<UserInfoProvider>(
              builder: (context, userData, child) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            userData.isCm = true;
                            userData.updateHeight();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: userData.isCm
                                  ? Colors.white
                                  : Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                TextConstants.cm,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: userData.isCm
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
                            userData.isCm = false;
                            userData.updateHeight();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: userData.isCm
                                  ? Colors.grey[200]
                                  : Colors.white,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                TextConstants.ft,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: userData.isCm
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
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<UserInfoProvider>(
              builder: (context, userData, child) {
                return Text(
                  userData.isCm
                      ? "${userData.heightCm} cm"
                      : "${userData.heightFt} ' ${userData.heightInch}\"",
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 30),
            Consumer<UserInfoProvider>(
              builder: (context, userData, child) {
                return Container(
                  width: 165,
                  height: 270,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        right: 3,
                        bottom: 45,
                        top: 15,
                        child: CustomPaint(
                          painter: RulerPainterFunction(),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 10,
                        child: Center(
                          child: Column(
                            children: [
                              userData.isCm
                                  ? NumberPicker(
                                      value: userData.heightCm,
                                      minValue: 50,
                                      maxValue: 250,
                                      onChanged: (value) {
                                        userData.heightCm = value;
                                        userData.updateHeight();
                                      },
                                      axis: Axis.vertical,
                                      itemHeight: 80,
                                      itemWidth: 70,
                                      textStyle: const TextStyle(fontSize: 20),
                                      selectedTextStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        NumberPicker(
                                          value: userData.heightFt,
                                          minValue: 1,
                                          maxValue: 8,
                                          onChanged: (value) {
                                            userData.heightFt = value;
                                            userData.updateHeight();

                                          },
                                          axis: Axis.vertical,
                                          itemHeight: 48,
                                          itemWidth: 30,
                                          itemCount: 5,
                                          textStyle: const TextStyle(fontSize: 20),
                                          selectedTextStyle: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "'",
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        NumberPicker(
                                          value: userData.heightInch,
                                          minValue: 0,
                                          maxValue: 12,
                                          onChanged: (value) {
                                            userData.heightInch = value;
                                            userData.updateHeight();
                                          },
                                          axis: Axis.vertical,
                                          itemHeight: 48,
                                          itemWidth: 35,
                                          itemCount: 5,
                                          textStyle: const TextStyle(fontSize: 20),
                                          selectedTextStyle: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 40,
                        top: 0,
                        bottom: 23,
                        child: Center(
                          child: Icon(
                            Icons.arrow_right,
                            size: 30,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
