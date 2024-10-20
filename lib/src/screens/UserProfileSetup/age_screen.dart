import 'package:fitelevate/src/screens/UserProfileSetup/userinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../constants/text_constants.dart';

class AgeScreen extends StatelessWidget {
  const AgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserInfoProvider>(context);

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
              TextConstants.age_title,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 10),
            const Text(
              TextConstants.age_subtitle,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 125,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: NumberPicker(
                      value: userDataProvider.age,
                      // Initialize with provider's age
                      minValue: 10,
                      maxValue: 100,
                      onChanged: (newValue) {
                        userDataProvider.age =
                            newValue; // Update directly via provider
                      },
                      itemHeight: 98,
                      // Adjust itemHeight to fit the container
                      textStyle: const TextStyle(fontSize: 20),
                      selectedTextStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    child: Container(
                      height: 1,
                      width: 125,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    bottom: 120,
                    child: Container(
                      height: 1,
                      width: 125,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
