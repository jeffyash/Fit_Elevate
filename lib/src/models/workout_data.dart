class WorkoutData {
  final String title;
  final String subtitle;
  final String image;

  const WorkoutData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
class ExercisesData {
  final String videoTitle;
  final String duration;
  final String thumbNail;
  final String videoUrl; // URL or asset path for the workout video
  final double caloriesBurned;

  ExercisesData({
    required this.videoTitle,
    required this.thumbNail,
    required this.duration,
    required this.videoUrl,
    required this.caloriesBurned,
  });
}
