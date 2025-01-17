import 'dart:async'; // Add this import for Timer
import 'package:flutter/material.dart';
import 'details_screen.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final String workoutType;

  WorkoutSessionScreen({required this.workoutType});

  @override
  _WorkoutSessionScreenState createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _seconds = 0;
  bool _isRunning = false;
  late Stopwatch _stopwatch;
  late Timer _timer;

  double _caloriesBurned = 0.0;
  double _distanceCovered = 0.0;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _startTimer(); // Start the timer immediately when the screen loads
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
      _timer = Timer.periodic(Duration(seconds: 1), _updateTime); // Start periodic timer
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
      _timer.cancel(); // Cancel the periodic timer when paused
    });
  }

  void _stopSession() {
    setState(() {
      _isRunning = false;
      _stopwatch.reset();
      _timer.cancel(); // Cancel the timer when the session is stopped
    });
    Navigator.pop(context);
  }

  void _updateTime(Timer timer) {
    setState(() {
      _seconds = _stopwatch.elapsed.inSeconds; // Update the seconds

      // Simulate calories burned and distance covered over time
      _caloriesBurned = (_seconds / 60) * 10; // 10 calories per minute
      _distanceCovered = (_seconds / 60) * 0.5; // 0.5 km per minute
    });
  }

  String _formatTime() {
    final int minutes = _seconds ~/ 60;
    final int seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Session - ${widget.workoutType}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _formatTime(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Icon(Icons.directions_walk, size: 100),
            SizedBox(height: 16),
            _buildProgressIndicator('Calories Burned', _caloriesBurned / 1000), // 1000 for full progress
            _buildProgressIndicator('Distance Covered', _distanceCovered / 5), // 5 km for full progress
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  child: Text(_isRunning ? 'Pause' : 'Resume'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _stopSession,
                  child: Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalkScreen()),
                );
              },
              child: Text('View Map'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        LinearProgressIndicator(
          value: value, // Dynamic progress
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
