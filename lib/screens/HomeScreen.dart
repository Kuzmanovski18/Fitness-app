import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'details_screen.dart'; // Assuming WalkScreen is in a separate file
import 'workout_selection_screen.dart';
import 'current_session_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDayIndex = 0; // Index for the selected day
  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"]; // For displaying day names

  // Function to get the last 5 days (formatted dates without the year)
  List<String> getLastFiveDays() {
    final today = DateTime.now();
    List<String> lastFiveDays = [];
    for (int i = 0; i < 5; i++) {
      final date = today.subtract(Duration(days: i));
      final formattedDate = DateFormat('dd/MM').format(date); // Format without the year
      lastFiveDays.add(formattedDate);
    }
    return lastFiveDays;
  }

  @override
  Widget build(BuildContext context) {
    final lastFiveDays = getLastFiveDays(); // Get the last 5 days

    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness Tracker"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Day selector row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(lastFiveDays.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedDayIndex == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          lastFiveDays[index], // Display the formatted date without the year
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          days[index], // Day abbreviation (Mon, Tue, etc.)
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              padding: const EdgeInsets.all(16),
              children: [
                // Walk button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalkScreen(),
                      ),
                    );
                  },
                  child: ActivityCard(
                    title: "Walk",
                    value: "0 Steps", // Start from 0 steps
                    icon: Icons.directions_walk,
                  ),
                ),
                // Other activity cards
                ActivityCard(
                  title: "Sleep",
                  value: "6 Hours",
                  icon: Icons.bed,
                ),
                ActivityCard(
                  title: "Water",
                  value: "3 Bottles",
                  icon: Icons.local_drink,
                ),
                ActivityCard(
                  title: "Heart",
                  value: "95 bpm",
                  icon: Icons.favorite,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkoutSelectionScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutSessionScreen(workoutType: 'Default')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "New Session",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Session",
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ActivityCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF161626),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 40),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
