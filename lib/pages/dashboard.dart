import 'package:fire_program/pages/news.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'calculator.dart';
import 'info.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 1; // Tracks the selected tab index
  Color backIcon = Colors.white;
  Color selectIcon = const Color.fromRGBO(255, 75, 0, 100);
  Color backgroundColor = Colors.white;
  final PageController _pageController = PageController(initialPage: 1); // PageController for smooth transitions

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const Calc(),
      const Home(),
      // const Info(),
      const News(),
    ];

    return Scaffold(
      extendBody: true, // Allows the body to extend under the BottomAppBar
      body: PageView(
        controller: _pageController, // Connect PageView with PageController
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update currentIndex when page is swiped
          });
        },
        physics: const NeverScrollableScrollPhysics(), // Disables swipe gestures
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom==0.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                _currentIndex = 1; // Set to the Home page
              });
              _pageController.animateToPage(1, // Animate to the Home page
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            shape: const CircleBorder(),
            child: Icon(
              Icons.home_outlined,
              color: selectIcon,
            ),
          ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 0; // Navigate to Calc
                });
                _pageController.animateToPage(0, // Animate to the Calc page
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              icon: Icon(
                Icons.calculate_outlined,
                color: selectIcon,
              ),
            ),
            const SizedBox(width: 40), // Adds space for the floating action button
            IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 2; // Navigate to Info
                });
                _pageController.animateToPage(2, // Animate to the Info page
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              icon: Icon(
                Icons.info_outline,
                color: selectIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
