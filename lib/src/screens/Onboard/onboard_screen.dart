import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:fitelevate/src/screens/Onboard/get_started.dart';
import 'package:fitelevate/src/constants/path_constants.dart';
import 'package:flutter/material.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<String> _titles = [
    TextConstants.onboarding1Title,
    TextConstants.onboarding2Title,
    TextConstants.onboarding3Title,
    TextConstants.onboarding4Title,
  ];

  final List<String> _descriptions = [
   TextConstants.onboarding1Description,
    TextConstants.onboarding2Description,
    TextConstants.onboarding3Description,
    TextConstants.onboarding4Description
  ];

  final List<String> _imageUrls = [
    PathConstants.fitModel1,
    PathConstants.fitModel2,
    PathConstants.fitModel3,
    PathConstants.fitModel4
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: _imageUrls.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_imageUrls[index]),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top:450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _titles[index],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          _descriptions[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: screenHeight,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          if (_currentIndex == 0)
            Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetStarted()),
                );
              },
              child: const Text(
                "Skip",
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentIndex == _imageUrls.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetStarted()),
                  );
                } else {
                  _controller.nextPage();
                }
              },
              child: const Text("Next >>",
                style:  TextStyle(
                  fontSize: 20,
                ),),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _imageUrls.length; i++) {
      indicators.add(Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == i ? Colors.purple : Colors.white,
        ),
      ));
    }
    return indicators;
  }
}
