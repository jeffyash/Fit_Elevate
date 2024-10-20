import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/screens/Diet/dietPlansPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Home/home.dart';
import '../MealTracking/meal_logging.dart';
import '../More/profile_info.dart';
import '../Workouts/workoutspage.dart';
import 'homepage_provider.dart';

class HomePage extends StatelessWidget {

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    DietPlanPage(),
    Workouts(),
    More(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context);
    return Scaffold(
      body: PageView(
        controller: provider.pageController,
        children: _widgetOptions,
        onPageChanged: provider.onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: provider.selectedIndex,
        onTap: (index) {
          provider.setPage(
              index); // This updates the index and changes the page
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white, size: 20,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant, color: Colors.white, size: 20),
            label: 'Diet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center, color: Colors.white, size: 20),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: Colors.white, size: 20),
            label: 'More',
          ),
        ],
        backgroundColor: ColorConstants.primaryColor,
        selectedItemColor: ColorConstants.white,
        unselectedItemColor: ColorConstants.white,
        selectedLabelStyle: TextStyle(fontSize: 14,),
        unselectedLabelStyle: TextStyle(fontSize: 14,),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MealTrackerPage()));
        },
        child: Icon(
          Icons.add,
          color: ColorConstants.white,
        ),
        shape: RoundedRectangleBorder( // Optional, ensures a circular shape
          borderRadius: BorderRadius.circular(50.0),
        ),
        backgroundColor: ColorConstants.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}