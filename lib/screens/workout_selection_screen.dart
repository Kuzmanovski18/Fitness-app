import 'package:flutter/material.dart';
import 'current_session_screen.dart'; // Import your session screen file

class WorkoutSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWorkoutOption(context, 'Weights', Icons.fitness_center),
            _buildWorkoutOption(context, 'Running', Icons.run_circle),
            _buildWorkoutOption(context, 'Bike', Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutOption(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutSessionScreen(workoutType: title),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Icon(icon, size: 40),
          title: Text(title),
        ),
      ),
    );
  }
}