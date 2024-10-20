import 'package:fitelevate/src/constants/path_constants.dart';
import 'package:fitelevate/src/screens/More/profile_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:provider/provider.dart';
import '../../constants/text_constants.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  String? selectedGender;
  String? selectedGoalPace;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController targetWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileInfoProvider = Provider.of<ProfileInfoProvider>(context, listen: false);
      try {
        await profileInfoProvider.initialize(); // Ensure _userId is set
        await profileInfoProvider.fetchUserInfo();
        setState(() {
          nameController.text = profileInfoProvider.userName;
          phoneNumberController.text = profileInfoProvider.phoneNumber;
          emailController.text = profileInfoProvider.email;
          ageController.text = profileInfoProvider.age.toString();
          heightController.text = profileInfoProvider.heightCm.toString();
          weightController.text = profileInfoProvider.weightKg.toString();
          targetWeightController.text = profileInfoProvider.targetWeightKg.toString();
          selectedGender = profileInfoProvider.gender;
          selectedGoalPace = profileInfoProvider.calorieGoal;
        });
      } catch (e) {
        print('Error initializing profile info: $e');
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    targetWeightController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileInfoProvider>(builder: (context, profileInfo, child) {
      // Lists of goal pace options based on the goal type
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

      final isWeightLoss = profileInfo.goal == 'Weight Loss';
      final isWeightGain = profileInfo.goal == 'Weight Gain';
      final isMuscleGain = profileInfo.goal == 'Gain Muscle';

      final titles = isWeightLoss
          ? loseTitles
          : (isWeightGain
          ? gainTitles
          : (isMuscleGain ? muscleGainTitles : []));

      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Basic Information",
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  // Collect values from controllers
                  final name = nameController.text;
                  final phoneNumber = phoneNumberController.text;
                  final email = emailController.text;
                  final age = int.tryParse(ageController.text) ?? 0;
                  final height = int.tryParse(heightController.text) ?? 0;
                  final weight = double.tryParse(weightController.text) ?? 0.0;
                  final targetWeight = double.tryParse(targetWeightController.text) ?? 0.0;
                  final gender = selectedGender ?? '';
                  final calorieGoal = selectedGoalPace ?? '';

                  // Call the updateBasicInfo method from ProfileInfoProvider
                  Provider.of<ProfileInfoProvider>(context, listen: false).updateBasicInfo(
                    userName: name,
                    email: email,
                    phoneNumber: phoneNumber,
                    gender: gender,
                    heightCm: height,
                    weightKg: weight,
                    targetWeightKg: targetWeight,
                    age: age,
                    calorieGoal: calorieGoal,
                  );

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Information saved successfully!'),
                      duration: Duration(seconds: 2), // Duration for how long the SnackBar will be visible
                    ),
                  );
                },
                child: Text(
                  "SAVE",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorConstants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          flexibleSpace: PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.name),
                      width: 30,
                      height: 30),
                  title: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.gender),
                      width: 30,
                      height: 30),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedGender = "Male";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedGender == "Male"
                              ? ColorConstants.primaryColor
                              : ColorConstants.bodyColor,
                          foregroundColor: selectedGender == "Male"
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: const Text("Male"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedGender = "Female";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedGender == "Female"
                              ? ColorConstants.primaryColor
                              : ColorConstants.bodyColor,
                          foregroundColor: selectedGender == "Female"
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: const Text("Female"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.phoneNumber),
                      width: 30,
                      height: 30),
                  title: TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.email),
                      width: 30,
                      height: 30),
                  title: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.age),
                      width: 30,
                      height: 30),
                  title: TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.height),
                      width: 30,
                      height: 30),
                  title: TextField(
                    controller: heightController,
                    decoration: const InputDecoration(
                      labelText: "Height (cm)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.weight),
                      width: 30,
                      height: 30),
                  title: TextField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: "Weight (kg)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ListTile(
                  leading: Image(
                      image: AssetImage(PathConstants.target),
                      width: 30,
                      height: 30),
                  title: TextField(
                    controller: targetWeightController,
                    decoration: const InputDecoration(
                      labelText: "Target Weight (kg)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ListTile(
                  leading: Image(
                    image: AssetImage(PathConstants.goalPace),
                    width: 30,
                    height: 30,
                  ),
                  title: DropdownButton<String>(
                    value: selectedGoalPace,
                    items: titles.map((title) {
                      return DropdownMenuItem<String>(
                        value: title,
                        child: Text(title),
                      );
                    }).toList(),
                    onChanged: profileInfo.goal == 'Maintain Weight' ? null : (value) {
                      setState(() {
                        selectedGoalPace = value;
                      });
                    },
                    hint: Text("Select Your Goal"),
                    // Conditionally disable the dropdown
                    isExpanded: true,
                    disabledHint: Text("Dropdown is disabled"), // Optional: Hint text when disabled
                  ),
                )

              ],
            ),
          ),
        ),
      );
    });
  }
}
