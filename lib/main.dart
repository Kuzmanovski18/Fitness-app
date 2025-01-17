import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Import provider package
import 'screens/details_screen.dart';
import 'screens/HomeScreen.dart';
import 'screens/workout_selection_screen.dart';
import 'screens/current_session_screen.dart';
import 'service/step_tracker.dart';  // Import the StepTracker

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StepTracker(),  // Provide StepTracker to all screens
      child: MaterialApp(
        title: 'Fitness Tracker',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/details': (context) => WalkScreen(),
          '/workout': (context) => WorkoutSelectionScreen(),
          '/session': (context) => WorkoutSessionScreen(workoutType: 'Default'),
        },
      ),
    );
  }
}
