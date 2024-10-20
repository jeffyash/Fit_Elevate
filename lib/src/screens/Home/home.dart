import 'package:fitelevate/src/screens/HomePage/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Steps Tracker/steps_count_card.dart';
import 'Steps Tracker/steps_tracking_screen.dart';
import 'Water Tracker/water_track_screen.dart';
import 'Water Tracker/water_tracking_provider.dart';
import 'WeightTracker/weight_card.dart';
import 'WeightTracker/weight_tracker.dart';
import 'Widgets/CalorieCard.dart';
import 'Calories Burned Tracker/CaloriesBurnedCard.dart';

import 'Water Tracker/waterTrackerCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageProvider>(
      builder: (context, homePageProvider, child){
        return Scaffold(
              appBar: AppBar(
                title: Text( '${homePageProvider.getGreeting()}'),
                automaticallyImplyLeading: false,
                flexibleSpace: PreferredSize(
                  preferredSize: Size.fromHeight(56.0),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: CaloriesCard(),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding:
                      EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Text("Trackers", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 16.0, // Horizontal space between grid items
                      mainAxisSpacing: 5.0, // Vertical space between grid items
                      childAspectRatio: 150 / 200, // Aspect ratio (width/height)
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final List<Widget> gridItems = [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                                onTap: () {
                                  final dailyWaterIntake =
                                      Provider.of<WaterIntakeProvider>(context,
                                          listen: false)
                                          .dailyWaterIntake;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WaterTrackingPage(
                                          dailyWaterIntake: dailyWaterIntake),
                                    ),
                                  );
                                },
                                child:const  WaterTrackerCard()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WeightTrackerScreen(),
                                    ),
                                  );
                                },
                                child: WeightCard()),
                          ),
                          const Padding(
                            padding:  EdgeInsets.all(12.0),
                            child: CaloriesBurned(progressValue: 0.25),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StepTrackingScreen(),
                                    ),
                                  );
                                },
                                child: const StepsCountCard()),
                          ),
                        ];
                        return gridItems[index];
                      },
                      childCount: 4, // Number of items in the grid
                    ),
                  ),
                ],
              ),
            );
          }
    );
  }
}
