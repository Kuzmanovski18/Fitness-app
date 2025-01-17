import 'dart:async'; // For the Timer
import 'package:flutter/material.dart';

class StepTracker extends ChangeNotifier {
  int _steps = 0;
  Duration _duration = Duration(seconds: 0);
  double _calories = 0.0;

  Timer? _timer; // Timer to update steps automatically

  int get steps => _steps;
  Duration get duration => _duration;
  double get calories => _calories;

  // Function to start the automatic increment of steps, duration, and calories
  void startTracking() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _steps += 1; // Increment steps
      _duration = Duration(seconds: _duration.inSeconds + 1); // Increment duration
      _calories = (_steps / 100) * 3.59; // Calculate calories burned

      notifyListeners(); // Notify listeners to update the UI
    });
  }

  // Function to stop the tracking
  void stopTracking() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel the timer
      _timer = null;
    }
  }

  // Function to reset the tracker
  void reset() {
    stopTracking(); // Stop the timer
    _steps = 0;
    _duration = Duration(seconds: 0);
    _calories = 0.0;

    notifyListeners(); // Notify listeners to update the UI
  }

  @override
  void dispose() {
    stopTracking(); // Ensure the timer is stopped when the class is disposed
    super.dispose();
  }
}
