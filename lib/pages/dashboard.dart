

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
  int _currentIndex = 1;
  Color backIcon = Colors.white;
  Color selectIcon = const Color.fromRGBO(255, 75, 0, 100);
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages=[
      Calc(),
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
                    Icons.calculate_outlined),
                label: "Calculate",
                backgroundColor: backIcon),
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.home_outlined),
                label: 'Home',
                backgroundColor: backIcon),
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.info_outline),
                label: "Info",
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
