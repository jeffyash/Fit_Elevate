import 'package:fitelevate/src/screens/More/profile_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/color_constants.dart';
import '../../constants/path_constants.dart';
import '../../constants/text_constants.dart';

class DietPreferenceUpdate extends StatefulWidget {
  const DietPreferenceUpdate({super.key});

  @override
  _DietPreferenceUpdateState createState() => _DietPreferenceUpdateState();
}

class _DietPreferenceUpdateState extends State<DietPreferenceUpdate> {
  late Set<String> selectedPreferences;

  @override
  void initState() {
    super.initState();
    final profileInfo = Provider.of<ProfileInfoProvider>(context, listen: false);
    selectedPreferences = profileInfo.dietPreferences.isEmpty
        ? {}
        : profileInfo.dietPreferences.toSet();
  }

  void updatePreferences() {
    final profileInfo = Provider.of<ProfileInfoProvider>(context, listen: false);
    profileInfo.updateDietPreferences(selectedPreferences.toList());
    // Optionally, you can add Firestore update logic here
    // updateFirestoreDietPreferences(selectedPreferences.toList());
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dietOptions = [
      TextConstants.fruits,
      TextConstants.vegetables,
      TextConstants.fish,
      TextConstants.egg,
      TextConstants.poultry,
      TextConstants.meat,
      TextConstants.dairy,
      TextConstants.vegan,
      TextConstants.organic,
      TextConstants.gluten_free,
      TextConstants.low_carb,
      TextConstants.whole_grain,
    ];
    final List<String> dietIconOptions = [
      PathConstants.fruits,
      PathConstants.vegetables,
      PathConstants.fish,
      PathConstants.egg,
      PathConstants.poultry,
      PathConstants.meat,
      PathConstants.dairy,
      PathConstants.vegan,
      PathConstants.organic,
      PathConstants.glutenFree,
      PathConstants.lowCarb,
      PathConstants.wholeGrain,
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Update Diet Preferences'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: dietOptions.length,
                itemBuilder: (context, index) {
                  final option = dietOptions[index];
                  final iconsOption = dietIconOptions[index];
                  final isSelected = selectedPreferences.contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedPreferences.remove(option);
                        } else {
                          selectedPreferences.add(option);
                        }
                      });
                    },
                    child: Card(
                      color: isSelected ? ColorConstants.primaryColor : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage(iconsOption),
                            width: 50,
                            height: 50,
                            color: isSelected ? Colors.white : ColorConstants.primaryColor,
                          ),
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              updatePreferences();
              // Optionally, show a confirmation or success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Diet preferences updated')),
              );
            },
            child: Text('Update',style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
