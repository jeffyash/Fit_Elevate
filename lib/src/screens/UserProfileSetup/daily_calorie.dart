import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/text_constants.dart';
import 'userinfo_provider.dart';

class DailyCalorie extends StatelessWidget {
  const DailyCalorie({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final userDataProvider = Provider.of<UserInfoProvider>(context);

    final List<String> loseTitles = [
      TextConstants.loseTitle1,
      TextConstants.loseTitle2,
      TextConstants.loseTitle3,
      TextConstants.loseTitle4,
    ];

    final List<String> gainTitles = [
      TextConstants.gainTitle1,
      TextConstants.gainTitle2,
      TextConstants.gainTitle3,
      TextConstants.gainTitle4,
    ];

    final List<String> muscleGainTitles = [
      TextConstants.muscleGainTitle1,
      TextConstants.muscleGainTitle2,
    ];

    // Determine the user-selected goal
    final isWeightLoss = userDataProvider.goal == 'Weight Loss';
    final isWeightGain = userDataProvider.goal == 'Weight Gain';
    final isMaintainWeight = userDataProvider.goal == 'Maintain Weight';
    final isMuscleGain = userDataProvider.goal == 'Gain Muscle';

    final titles = isWeightLoss
        ? loseTitles
        : (isWeightGain
        ? gainTitles
        : (isMuscleGain ? muscleGainTitles : []));

    // Calculate the daily calorie intake
    final dailyCalorieIntake = userDataProvider.calculateDailyCalorieBurn();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (isMaintainWeight) ...[
                  Text(
                    "${dailyCalorieIntake.toInt()} Kcal",
                    style: const TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    TextConstants.dailyCalorie_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  Text(
                    "${dailyCalorieIntake.toInt()} Kcal",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    TextConstants.dailyCalorie_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TextConstants.weeklyGoal,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ...titles.map((title) {
                    return Consumer<UserInfoProvider>(
                      builder: (context, provider, child) {
                        return ListTile(
                          onTap: () {
                            provider.selectedCalorieGoal = title;
                          },
                          leading: Radio<String>(
                            value: title,
                            groupValue: provider.selectedCalorieGoal,
                            onChanged: (value) {
                              provider.selectedCalorieGoal = value!;
                            },
                          ),
                          title: Text(title),
                          subtitle: Row(
                            children: [
                              const Text(TextConstants.calorieGoal),
                              Text(
                                '${provider.calculateDailyCalorieGoal(title).toInt()} kcal',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

}
