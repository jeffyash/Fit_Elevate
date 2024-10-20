import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/constants/path_constants.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:flutter/material.dart';
import '../UserAccount/SignUp/create_account_page.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  Widget buildFeatureTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 40),
      title: Text(title, style: const TextStyle(fontSize: 22, color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 15, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            PathConstants.backgroundImg,
            width: screenSize.width,
            height: screenSize.height,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TextConstants.getstarted_heading,
                        style: const TextStyle(fontSize: 25, color: ColorConstants.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      buildFeatureTile(Icons.directions_run, TextConstants.getstarted_title1, TextConstants.getstarted_subtitle1),
                      buildFeatureTile(Icons.calendar_month_sharp, TextConstants.getstarted_title2, TextConstants.getstarted_subtitle2),
                      buildFeatureTile(Icons.timeline, TextConstants.getstarted_title3, TextConstants.getstarted_subtitle3),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAccountPage()),
                      );
                    },
                    child: const Text(
                      "Get Started >>",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
