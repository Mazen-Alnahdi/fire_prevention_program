import 'dart:async';
import 'package:fire_program/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future <void> main() async{
  await dotenv.load(fileName: '.env');

  runApp(MaterialApp(home: Main(),));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  Color loadColor = Colors.red;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(); // Repeats the animation indefinitely

    _colorAnimation = ColorTween(
      begin: Color(0xFFFFFF),
      end: Colors.red,
    ).animate(_controller);
    // Navigate to the next screen after 3 seconds
    Timer(
      const Duration(seconds: 4),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashBoard()),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: RotationTransition(
          turns: _controller,
          child: Image.asset(
            'assets/img.png', // Replace with your image path
            width: 100, // Set image size
            height: 100,
          ),
        ),
      ),
    );
  }
}

