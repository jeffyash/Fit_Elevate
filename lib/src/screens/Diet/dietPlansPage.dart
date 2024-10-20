import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:flutter/material.dart';
import '../../constants/dietData_constants.dart';
import '../../constants/text_constants.dart';
import '../../models/diet_data.dart';
import 'widget/dietCard_Widget.dart';
import 'diet_plan_detail_page.dart';

class DietPlanPage extends StatelessWidget {

  Future<String?> _getUserGoal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('user_master')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final physicalAttributes = docSnapshot.data()?['physicalAttributes'] as Map<String, dynamic>?;
        if (physicalAttributes != null) {
          return physicalAttributes['goal'] as String?;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextConstants.dietPlans, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: FutureBuilder<String?>(
        future: _getUserGoal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching goal.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No goal found.'));
          }

          final userGoal = snapshot.data;
          List<DietPlanData> dietPlans;

          if (userGoal == TextConstants.weightGain) {
            dietPlans = DataConstants.weightgain_dietPlans;
          } else if (userGoal == TextConstants.weightLoss) {
            dietPlans = DataConstants.weightloss_dietPlans;
          } else if (userGoal == TextConstants.maintainWeight) {
            dietPlans = DataConstants.weightmaintenance_dietPlans;
          } else if (userGoal == TextConstants.muscleGain) {
            dietPlans = DataConstants.muscleGain_dietPlans;
          } else {
            dietPlans = []; // Handle case where goal doesn't match any known category
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: dietPlans.length,
              itemBuilder: (context, index) {
                final dietPlan = dietPlans[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DietPlanDetailPage(
                            dietPlan: dietPlan,
                            userGoal: userGoal!,
                          ),
                        ),
                      );
                    },
                    child: DietPlanCard(dietPlan: dietPlan),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
