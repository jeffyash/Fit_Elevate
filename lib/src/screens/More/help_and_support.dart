import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Help & Support',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF7265E3), // FitElevate primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Frequently Asked Questions (FAQs)'),
            _buildFAQItem('1. How do I create an account?',
                'To create an account, tap on the "Create Account" button on the home screen and follow the prompts to enter your details.'),
            _buildFAQItem('2. How can I reset my password?',
                'If you have forgotten your password, go to the login screen and tap on "Forgot Password?" to receive a reset link via email.'),
            _buildFAQItem('3. Can I change my diet preferences?',
                'Yes, you can update your diet preferences in the Profile section of the app.'),
            _buildFAQItem('4. How do I track my progress?',
                'You can track your progress by navigating to the Progress section in the app where you can view your weight changes and workout history.'),
            SizedBox(height: 16),
            _buildSectionTitle('Contact Support'),
            _buildSectionContent(
                'If you have any questions or need further assistance, please reach out to our support team:'),
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
            SizedBox(height: 16),
            _buildSectionTitle('Feedback'),
            _buildSectionContent(
                'We value your feedback! Please let us know your thoughts or suggestions for improving FitElevate. You can send your feedback directly to us at the email address above.'),
            SizedBox(height: 16),
            _buildSectionTitle('Help Resources'),
            _buildSectionContent(
                'Visit our website for additional resources, including workout guides, diet tips, and more:'),
            GestureDetector(
              onTap: () => _launchURL('https://fitelevate.in/help'),
              child: Text(
                'fitelevate.in/help',
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

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer, style: TextStyle(fontSize: 16)),
        ),
      ],
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

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
