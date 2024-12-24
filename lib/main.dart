import 'dart:async';
import 'package:fire_program/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

Future <void> main() async{
  await dotenv.load(fileName: '.env');

  runApp(MaterialApp(home: Main(),
  theme: ThemeData(
    fontFamily: GoogleFonts.openSans().fontFamily,
  ),));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
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

    _offsetAnimation = TweenSequence<Offset>([
      // Move fast to the center
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.0, 4.0),
          end: const Offset(0.0, 0.5), // Stops slightly above the center
        ).chain(CurveTween(curve: Curves.easeInExpo)),
        weight: 40, // 40% of the total animation time
      ),

      // Shake itself
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.0, 0.5),
          end: const Offset(0.0, -0.5),
        ).chain(CurveTween(curve: Curves.elasticIn)), // Elastic effect for shake
        weight: 30, // 30% of the total animation time
      ),

      // Move fast upward
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.0, -0.5),
          end: const Offset(0.0, -4.0), // Ends at the top
        ).chain(CurveTween(curve: Curves.easeOutExpo)),
        weight: 30, // 30% of the total animation time
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // Use linear here to allow the TweenSequence to control curves
    ));
    //
    // _colorAnimation = ColorTween(
    //   begin: Color(0xFFFFFF),
    //   end: Colors.red,
    // ).animate(_controller);
    // // Navigate to the next screen after 3 seconds
    Timer(
      const Duration(seconds: 5),
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
        child:

        SlideTransition(
          position: _offsetAnimation,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
          child: Image.asset(
              "assets/img.png",
          width: 100,
          height: 100,),
          ),
        )
        // RotationTransition(
        //   turns: _controller,
        //   child: Image.asset(
        //     'assets/img.png', // Replace with your image path
        //     width: 100, // Set image size
        //     height: 100,
        //   ),
        // ),
      ),
    );
  }
}

