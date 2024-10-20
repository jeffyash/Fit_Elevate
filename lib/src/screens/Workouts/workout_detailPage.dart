import 'package:flutter/material.dart';
import '../../models/workout_data.dart';
import 'video_player_screen.dart'; // Import the new VideoPlayerScreen

class WorkoutDetailScreen extends StatefulWidget {
  final List<ExercisesData> exercisesList;
  final String title;

  WorkoutDetailScreen({required this.exercisesList,required this.title});

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  int _currentIndex = 0;

  void _onExerciseSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

   // Navigate to the VideoPlayerScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: widget.exercisesList[_currentIndex].videoUrl,
          videoTitle: widget.exercisesList[_currentIndex].videoTitle, // Pass the title here
          caloriesBurned: widget.exercisesList[_currentIndex].caloriesBurned,
          duration: widget.exercisesList[_currentIndex].duration,
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.exercisesList.length,
              itemBuilder: (context, index) {
                final exercise = widget.exercisesList[index];
                return ListTile(
                  leading: Image(image: AssetImage(exercise.thumbNail),width: 120,height: 100,fit: BoxFit.cover,),
                  title: Text(exercise.videoTitle),
                  subtitle: Text(exercise.duration),
                  onTap: () => _onExerciseSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
