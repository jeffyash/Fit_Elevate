import 'package:fitelevate/src/constants/path_constants.dart';

import '../models/workout_data.dart';

class WorkoutConstants {
  static List<WorkoutData> workoutData = const [
    WorkoutData(
      title: 'Strength Training',
      subtitle: 'Build muscle and strength',
      image: 'images/strength_training.jpg',
    ),
    WorkoutData(
      title: 'Cardio Workout',
      subtitle: 'Improve your cardiovascular health',
      image: 'images/cardio_workout.png',
    ),
    WorkoutData(
      title: 'Zumba',
      subtitle: 'Fun dance workout',
      image: 'images/Zumba.jpg',
    ),
    WorkoutData(
      title: 'Yoga',
      subtitle: 'Improve flexibility and relaxation',
      image: 'images/yoga_woman.jpg',
    ),
  ];

  List<ExercisesData> strengthTraining = [
    ExercisesData(
        videoTitle: "Strength Training Fat Blaster ",
        duration: "30 mins",
        videoUrl: "https://www.youtube.com/watch?v=Pw7oma5Jh3M",
        thumbNail: PathConstants.strength1,
        caloriesBurned: 300),
    ExercisesData(
        videoTitle: "NO REPEAT Full Body Strength Training",
        duration: "30 mins",
        videoUrl: "https://www.youtube.com/watch?v=tj0o8aH9vJw",
        thumbNail: PathConstants.strength2,
        caloriesBurned: 300),
    ExercisesData(
        videoTitle: "FULL BODY STRENGTH Workout - With Weights",
        duration: "30 mins",
        videoUrl: "https://www.youtube.com/watch?v=LdFgFco_8p8",
        thumbNail: PathConstants.strength3,
        caloriesBurned:300),
    // Add more workouts here
  ];
  List<ExercisesData> cardioWorkout = [
    ExercisesData(
      videoTitle: "PUMPING CARDIO WORKOUT ",
      duration: "30 mins",
      videoUrl: "https://www.youtube.com/watch?v=kZDvg92tTMc",
      thumbNail: PathConstants.cardio1,
      caloriesBurned: 300,
    ),
    ExercisesData(
        videoTitle: "CARDIO WORKOUT AT HOME ",
        duration: "25 mins",
        videoUrl: "https://www.youtube.com/watch?v=OWGXhg50EHI",
        thumbNail: PathConstants.cardio2,
        caloriesBurned: 300),
    ExercisesData(
        videoTitle: "BEGINNER CARDIO Workout",
        duration: "15 mins",
        videoUrl: "https://www.youtube.com/watch?v=VWj8ZxCxrYk",
        thumbNail: PathConstants.cardio3,
        caloriesBurned: 300),

    // Add more workouts here
  ];
  List<ExercisesData> yoga = [
    ExercisesData(
        videoTitle: " FEEL GOOD YOGA ",
        duration: "20 mins",
        videoUrl: "https://www.youtube.com/watch?v=poZBpvLTHNw",
        thumbNail: PathConstants.yoga1,
        caloriesBurned: 300),
    ExercisesData(
        videoTitle: "Morning Yoga Flow ",
        duration: "20 mins",
        videoUrl: "https://www.youtube.com/watch?v=djLCTwi3PmU",
        thumbNail: PathConstants.yoga2,
        caloriesBurned: 300),
    // Add more workouts here
  ];
  List<ExercisesData> zumba = [
    ExercisesData(
        videoTitle: "Full Body FAT BURNING Workout",
        duration: "50 mins",
        videoUrl: "https://www.youtube.com/watch?v=O96NJ2ZlzUs",
        thumbNail: PathConstants.zumba1,
        caloriesBurned: 500),
    ExercisesData(
        videoTitle: "DWD DAILY FULLY BODY Dance Workout |",
        duration: "30 mins",
        videoUrl: "https://www.youtube.com/watch?v=aoQrCsOenJY",
        thumbNail: PathConstants.zumba2,
        caloriesBurned: 300),
    ExercisesData(
        videoTitle: "DWD DAILY FLAT BELLY Workout",
        duration: "30 mins",
        videoUrl: "https://www.youtube.com/watch?v=2ZdGw4hxRJs",
        thumbNail: PathConstants.zumba3,
        caloriesBurned: 350),
    // Add more workouts here
  ];
}
