import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitelevate/src/screens/More/profile_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Onboard/onboard_screen.dart';

class AccountSettingsPage extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final profileInfoProvider = Provider.of<ProfileInfoProvider>(context);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Settings',style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFF7265E3), // FitElevate primary color
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildSectionTitle('Account Options'),
              _buildChangePasswordButton(context),
              SizedBox(height: 16),
              _buildDeleteAccountButton(context, profileInfoProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to Change Password page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
        );
      },
      child: Text(
        'Change Password',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF7265E3), // FitElevate primary color
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context, ProfileInfoProvider profileInfoProvider) {
    return ElevatedButton(
      onPressed: () {
        // Show confirmation dialog for account deletion
        _showDeleteConfirmationDialog(context, profileInfoProvider);
      },
      child: Text(
        'Delete Account',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Red color for delete
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ProfileInfoProvider profileInfoProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await profileInfoProvider.deleteAccount(); // Call the delete method
                  // Show success message
                  _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(content: Text('Your account has been deleted successfully.')));
                  // Wait for 3 seconds before navigating
                  await Future.delayed(Duration(seconds: 3));

                  // Navigate back to OnboardPage, clearing the stack
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => OnboardPage()),
                        (Route<dynamic> route) => false, // Remove all previous routes
                  );
                } catch (e) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete account: $e')),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }



}

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Color(0xFF7265E3), // FitElevate primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text.trim();
                String newPassword = newPasswordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('New passwords do not match!'),
                  ));
                  return;
                }

                try {
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null && user.email != null) {
                    // Re authenticate the user
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: currentPassword,
                    );

                    await user.reauthenticateWithCredential(credential);

                    // Update the password
                    await user.updatePassword(newPassword);

                    // Save updated password info in SharedPreferences
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('password', newPassword);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Password changed successfully!'),
                    ));

                    Navigator.pop(context); // Go back after successful password change
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error: ${e.toString()}'),
                  ));
                }
              },
              child: Text(
                'Change Password',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7265E3), // FitElevate primary color
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

