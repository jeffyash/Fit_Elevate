import 'package:fitelevate/src/screens/HomePage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Home/Calories Burned Tracker/CaloriesBurnedProvider.dart';


class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final double caloriesBurned;
  final String duration;

  VideoPlayerScreen({
    required this.videoUrl,
    required this.videoTitle,
    required this.caloriesBurned,
    required this.duration,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false; // Track full-screen status
  bool _isVideoEnded = false;  // Track if video has ended

  @override
  void initState() {
    super.initState();

    // Extract the video ID from the YouTube URL
    final videoID = YoutubePlayer.convertUrlToId(widget.videoUrl);

    // Initialize the YouTube player controller
    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Add listeners to handle full-screen state changes
    _controller.addListener(() {
      if (_controller.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller.value.isFullScreen;
        });
      }

      // Check if the video has ended
      if (_controller.value.playerState == PlayerState.ended) {
        setState(() {
          _isVideoEnded = true; // Video has ended
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check the device orientation
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: _isFullScreen
          ? null // Hide the app bar in full-screen mode
          : AppBar(
        title: Text(widget.videoTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use Expanded to prevent overflow
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () => debugPrint("YouTube Player is ready"),
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                ),
                FullScreenButton(),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Only show the text when not in full-screen mode
          if (!_isFullScreen) ...[
            // Adjusted Padding with EdgeInsets.symmetric
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: orientation == Orientation.portrait ? 16.0 : 32.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duration: ${widget.duration}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Calories: ${widget.caloriesBurned.toStringAsFixed(1)} cal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Padding(
                // Added Padding for the ElevatedButton
                padding: EdgeInsets.symmetric(
                  horizontal: orientation == Orientation.portrait ? 16.0 : 32.0,
                  vertical: 8.0,
                ),
                child: ElevatedButton(
                  onPressed: _isVideoEnded ? () {
                    final caloriesBurnedProvider =
                    Provider.of<CaloriesBurnedProvider>(context, listen: false);

                    // Update calories burned
                    caloriesBurnedProvider.updateCaloriesBurned(widget.caloriesBurned);

                    // Add the workout title
                    caloriesBurnedProvider.addWorkoutTitle(widget.videoTitle);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                    );
                    print('calories tracked ${widget.caloriesBurned}');
                  } : null, // Disable button if video hasn't ended
                  child: Text(_isVideoEnded ? 'Track this workout' : 'Finish watching to track workout'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
