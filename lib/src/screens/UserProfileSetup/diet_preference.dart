import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/color_constants.dart';
import '../../constants/path_constants.dart';
import '../../constants/text_constants.dart';
import 'userinfo_provider.dart'; // Import the UserDataProvider

class DietPreference extends StatelessWidget {
  const DietPreference({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserInfoProvider>(context);
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

    // Ensure selectedPreferences is initialized correctly
    final Set<String> selectedPreferences = userData.dietPreferences.isEmpty
        ? {}
        : userData.dietPreferences.toSet();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              TextConstants.dietpref_title,
              style: TextStyle(fontSize: 25),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                TextConstants.dietpref_subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
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
                      if (isSelected) {
                        selectedPreferences.remove(option);
                      } else {
                        selectedPreferences.add(option);
                      }
                      // Notify UserDataProvider of changes
                      userData.dietPreferences = selectedPreferences.toList();
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
        ],
      ),
    );
  }
}
