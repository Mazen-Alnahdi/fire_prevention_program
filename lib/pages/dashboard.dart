

import 'package:flutter/material.dart';

import 'home.dart';
import 'calculator.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  Color backIcon = Colors.red;
  Color selectIcon = Colors.orange;
  Color backgroundColor = Colors.orange;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages=[
      Home(),
      Info(),
    ];

    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: _pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.home),
                label: 'Home',
                backgroundColor: backIcon),
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.help),
                label: "Help",
                backgroundColor: backIcon),
          ],
        currentIndex: _currentIndex,
        selectedItemColor: selectIcon,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index){
    setState(() {
      _currentIndex=index;
    });
  }
}
