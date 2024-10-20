import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About FitElevate',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7265E3), // FitElevate primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'About FitElevate',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'FitElevate is your personalized fitness companion, designed to help you reach your health and wellness goals. Whether you\'re looking to lose weight, build muscle, or improve your overall fitness, our app provides tailored workout plans, diet recommendations, and progress tracking.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Key Features'),
            _buildSectionContent(
              '- Personalized workout and diet plans based on your goals and preferences.\n\n'
                  '- Track your daily calorie intake, calories burned, and water consumption.\n\n'
                  '- Receive workout suggestions based on your activity level and progress.\n\n'
                  '- Set fitness goals, track your weight, and monitor your progress over time.\n\n'
                  '- Get reminders to stay hydrated and on track with your fitness routine.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Our Mission'),
            _buildSectionContent(
              'At FitElevate, our mission is to empower people to live healthier, happier lives by making fitness accessible, personalized, and engaging. We believe that fitness should be for everyone, no matter their level of experience or fitness goals.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Our Team'),
            _buildSectionContent(
              'FitElevate was developed by a team of fitness enthusiasts and tech experts committed to creating an intuitive, user-friendly app that delivers real results. Our team is constantly working to improve the app, adding new features and listening to user feedback to ensure the best possible experience.',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Contact Us'),
            _buildSectionContent(
                'If you have any questions, feedback, or suggestions, feel free to contact us:'),
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
            _buildSectionTitle('Follow Us'),
            _buildSectionContent('Stay connected and follow us on our social media platforms:'),
            Row(
              children: [
                _buildSocialMediaIcon(
                    FontAwesomeIcons.facebook, 'https://facebook.com/fitelevate'),
                SizedBox(width: 10),
                _buildSocialMediaIcon(
                    FontAwesomeIcons.twitter, 'https://twitter.com/fitelevate'),
                SizedBox(width: 10),
                _buildSocialMediaIcon(
                    FontAwesomeIcons.instagram, 'https://instagram.com/fitelevate'),
              ],
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

  Widget _buildSocialMediaIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: FaIcon(
        icon,
        size: 30,
        color: Colors.blue,
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

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
