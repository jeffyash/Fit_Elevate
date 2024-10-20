import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitelevate/src/screens/Home/WeightTracker/weight_data_provider.dart';
import 'package:fitelevate/src/screens/Home/WeightTracker/weight_progress_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/date_utils.dart';
import '../../../constants/color_constants.dart';


class WeightTrackerScreen extends StatefulWidget {
  const WeightTrackerScreen({super.key});

  @override
  State<WeightTrackerScreen> createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weightTrackerProvider = Provider.of<WeightTrackerProvider>(context, listen: false);
      weightTrackerProvider.initialize();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        weightTrackerProvider.fetchUserWeightData(user.uid);
      } else {
        print('No user is currently signed in.');
      }
    });
  }

  double calculateProgress(String goal, double initialWeight, double currentWeight, double targetWeight) {
    switch (goal) {
      case 'Weight Loss':
        final weightLost = initialWeight - currentWeight;
        final totalWeightToLose = initialWeight - targetWeight;
        return (weightLost / totalWeightToLose).clamp(0.0, 1.0);
      case 'Weight Gain':
        final weightGained = currentWeight - initialWeight;
        final totalWeightToGain = targetWeight - initialWeight;
        return (weightGained / totalWeightToGain).clamp(0.0, 1.0);
      case 'Muscle Gain':
      // Assuming muscle gain goal means gaining weight while maintaining low body fat.
        final muscleGained = currentWeight - initialWeight; // This could be calculated more specifically.
        final totalMuscleToGain = targetWeight - initialWeight;
        return (muscleGained / totalMuscleToGain).clamp(0.0, 1.0);
      case 'Maintenance':
      // For maintenance, we consider weight fluctuations
        return (currentWeight - initialWeight).abs() < 1.0 ? 1.0 : 0.0; // 100% if within 1kg of the initial weight
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userWeight = Provider.of<WeightTrackerProvider>(context);
    final currentWeight = userWeight.currentWeightKg;
    final targetWeight = userWeight.targetWeightKg;
    final initialWeight = userWeight.initialWeight;
    final weightHistory = userWeight.weightHistory;

    // Assuming there is a way to retrieve the user's goal
    final goal = userWeight.goal; // Fetch the user's goal (e.g., "Weight Loss", "Weight Gain", etc.)

    // Calculate progress based on the user's goal
    final progress = calculateProgress(goal, initialWeight, currentWeight, targetWeight);

    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Tracker"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          color: ColorConstants.primaryColor,
                          backgroundColor: ColorConstants.primaryColor.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}% of goal reached',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Initial Weight Card
                      _buildWeightCard("Initial Weight", initialWeight),
                      // Current Weight Card
                      _buildWeightCard("Current Weight", currentWeight),
                      // Target Weight Card
                      _buildWeightCard("Target Weight", targetWeight),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Weight History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth,
                height: 410,
                color: ColorConstants.bodyColor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                  child: WeightProgressChart(
                    weightHistory: weightHistory,
                    formatDate: (date) => formatDate(date),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Weight'),
                content: UpdateWeightDialog(),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildWeightCard(String title, double weight) {
    return Container(
      height: 80,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: ColorConstants.bodyColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Text("$weight", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class UpdateWeightDialog extends StatefulWidget {
  @override
  _UpdateWeightDialogState createState() => _UpdateWeightDialogState();
}

class _UpdateWeightDialogState extends State<UpdateWeightDialog> {
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter your weight in kg',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final weightProvider = Provider.of<WeightTrackerProvider>(context, listen: false);
            final newWeight = double.tryParse(_weightController.text);
            if (newWeight != null) {
              weightProvider.updateWeight(newWeight);
              Navigator.of(context).pop(); // Close the dialog
            } else {
              // Show error if the input is not a valid number
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a valid weight')),
              );
            }
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
