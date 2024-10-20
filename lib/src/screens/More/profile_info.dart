import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/screens/More/about_Page.dart';
import 'package:fitelevate/src/screens/More/privacy_page.dart';
import 'package:fitelevate/src/screens/More/profile_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/path_constants.dart';
import '../UserAccount/Login/login_screen.dart';
import 'account_settings.dart';
import 'basic_info.dart';
import 'diet_preference_update.dart';


import 'help_and_support.dart'; // For File

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void initState() {
    super.initState();
    // Fetch user info when the widget is initialized
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final profileInfoProvider = Provider.of<ProfileInfoProvider>(context, listen: false);
    await profileInfoProvider.initialize(); // Initialize to set _userId
    await profileInfoProvider.fetchUserInfo(); // Fetch user
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileInfoProvider>(
      builder: (context, profileInfo, child) {


        final username = profileInfo.userName.isNotEmpty ? profileInfo.userName : 'Username';
        final age = '${profileInfo.age}';
        final height = '${profileInfo.heightCm} cm';
        final weight = '${profileInfo.weightKg} kg';
        final _imageFile=profileInfo.imageFile;
        print("ImageFile $_imageFile");

        // Gender-based profile image
        final profileImage = (profileInfo.gender == 'Male')
            ? PathConstants.profileImageMale
            : PathConstants.profileImageFemale;

        return Scaffold(
          appBar: AppBar(
            title: const Text('More'),
        flexibleSpace: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
        color: Colors.white,
        ),
          ),
          ),
          backgroundColor: Colors.white,
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: profileInfo.uploadedImageUrl != null
                              ? NetworkImage(profileInfo.uploadedImageUrl!)  // Use uploaded image if available
                              : AssetImage(profileImage) as ImageProvider,  // Default image for new users
                          radius: 60,
                        ),
                        Positioned(
                          top:80,
                          bottom: 4,
                          right: 15,
                          left: 80,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,size: 30,),
                            color: ColorConstants.primaryColor, // Trigger image selection
                            onPressed:(){
                              profileInfo.pickImage();
                            },  // Wrap in a lambda
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildInfoCard('Age', age),
                        buildInfoCard('Height', height),
                        buildInfoCard('Weight', weight),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicInfo()),
                  );
                },
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: const Text("Basic Information"),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DietPreferenceUpdate()),
                  );
                },
                leading: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.black,
                ),
                title: const Text("Diet Preferences"),
              ),
              const Divider(),
              // ListTile(
              //   onTap: () {
              //     // Navigate to notifications settings
              //   },
              //   leading: const Icon(
              //     Icons.notifications,
              //     color: Colors.black,
              //   ),
              //   title: const Text("Notifications"),
              // ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  PrivacyPolicyPage()),
                  );
                },
                leading: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                title: const Text("Privacy"),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AccountSettingsPage()),
                  );
                },
                leading: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: const Text("Account Settings"),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  HelpSupportPage()),
                  );
                },
                leading: const Icon(
                  Icons.help,
                  color: Colors.black,
                ),
                title: const Text("Help & Support"),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AboutPage()),
                  );
                },
                leading: const Icon(
                  Icons.info,
                  color: Colors.black,
                ),
                title: const Text("About"),
              ),
              ListTile(
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: const Text("Log Out"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildInfoCard(String label, String value) {
    return Container(
      width: 110,
      height: 100,
      child: Card(
        color: ColorConstants.bodyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // Clear all data from SharedPreferences
                await prefs.clear(); // This will clear all keys and values
                await prefs.setBool('isLoggedIn', false); // Clear session


                Navigator.of(context).pop(); // Dismiss the dialog
                // Perform the logout operation
                await FirebaseAuth.instance.signOut();
                // Redirect to the login screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
