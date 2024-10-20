import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;

  void setPage(int index) {
    _selectedIndex = index;
    _pageController.jumpToPage(index); // Change the page view
    notifyListeners();
  }

  void onPageChanged(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Method to get greeting message based on time of day
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
