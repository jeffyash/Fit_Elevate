import 'package:fitelevate/src/screens/UserProfileSetup/userinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/constants/text_constants.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key});

  void _selectGender(BuildContext context, String gender) {
    Provider.of<UserInfoProvider>(context, listen: false).gender = gender;
  }

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
              TextConstants.gender_title,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10,),
            const Text(
              TextConstants.gender_subtitle,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Consumer<UserInfoProvider>(
              builder: (context, userInfo, child) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectGender(context, 'Male'),
                      child: Container(
                        width: 320,
                        height: 75,
                        decoration: BoxDecoration(
                          color: userInfo.gender == 'Male'
                              ? ColorConstants.primaryColor
                              : ColorConstants.grey,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.male,
                                color: userInfo.gender == 'Male'
                                    ? ColorConstants.white
                                    : ColorConstants.textBlack,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                TextConstants.male,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: userInfo.gender == 'Male'
                                      ? ColorConstants.white
                                      : ColorConstants.textBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => _selectGender(context, 'Female'),
                      child: Container(
                        width: 320,
                        height: 75,
                        decoration: BoxDecoration(
                          color: userInfo.gender == 'Female'
                              ? ColorConstants.primaryColor
                              : ColorConstants.grey,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.female,
                                color: userInfo.gender == 'Female'
                                    ? ColorConstants.white
                                    : ColorConstants.textBlack,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                TextConstants.female,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: userInfo.gender == 'Female'
                                      ? ColorConstants.white
                                      : ColorConstants.textBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
