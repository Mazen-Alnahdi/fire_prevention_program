

import 'package:flutter/material.dart';

import 'home.dart';
import 'info.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  Color backIcon = Colors.black;
  Color selectIcon = Colors.white;

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
