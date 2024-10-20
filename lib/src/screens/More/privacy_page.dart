import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Color(0xFF7265E3), // FitElevate primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Privacy Policy for FitElevate',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'At FitElevate, we value your privacy and are committed to protecting your personal information. '
                  'This privacy policy explains how we collect, use, and safeguard your data when you use our mobile application and services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('1. Information We Collect'),
            _buildSectionContent(
              'We collect the following types of information:\n\n'
                  '- Personal Information: When you create an account on FitElevate, we collect information such as your name, email address, phone number, age, gender, height, weight, and dietary preferences. We may also collect information about your activity levels and goals.\n\n'
                  '- Usage Data: We collect data on how you use the app, such as workout logs, diet tracking, and fitness progress.\n\n'
                  '- Health Data: With your consent, we collect and process health-related data like daily calories burned, calories consumed, and other fitness metrics.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('2. How We Use Your Information'),
            _buildSectionContent(
              'FitElevate uses the information we collect to:\n\n'
                  '- Personalize your fitness and diet plans based on your preferences and goals.\n\n'
                  '- Track your progress and provide tailored workout recommendations.\n\n'
                  '- Send you notifications about your activity, goals, and app updates.\n\n'
                  '- Improve our app functionality, user experience, and content.\n\n'
                  '- Communicate with you regarding account updates, customer service, or app-related inquiries.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('3. Data Sharing'),
            _buildSectionContent(
              'We do not sell or rent your personal information to third parties. However, we may share data:\n\n'
                  '- With third-party service providers who assist in app functionality, such as cloud storage and analytics, but only to the extent necessary for them to perform their services.\n\n'
                  '- As required by law, if we need to disclose your data to comply with legal obligations or respond to lawful requests from authorities.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('4. Data Security'),
            _buildSectionContent(
              'We take appropriate security measures to protect your information from unauthorized access, alteration, or destruction. Your data is encrypted both in transit and at rest. However, please note that no method of data transmission over the internet is entirely secure.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('5. Your Rights'),
            _buildSectionContent(
              'You have the right to:\n\n'
                  '- Access, update, or delete your personal information at any time through your account settings.\n\n'
                  '- Withdraw consent for processing your health-related data or for receiving marketing communications.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('6. Third-Party Links'),
            _buildSectionContent(
              'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices or content of these third parties, and we encourage you to review their privacy policies.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('7. Changes to this Privacy Policy'),
            _buildSectionContent(
              'FitElevate may update this privacy policy from time to time. We will notify you of any significant changes by posting a notice within the app or by email.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('8. Contact Us'),
            _buildSectionContent(
              'If you have any questions or concerns about this privacy policy or your data, please contact us at: ',
            ),
            GestureDetector(
              onTap: () => _launchEmail(),
              child: Text(
                'support@fitelevate.in',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            ),
          ],
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

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@fitelevate.in',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }
}
