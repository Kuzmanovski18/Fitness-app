import 'dart:async'; // Import Timer class
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart'; // Import the provider package
import '../service/step_tracker.dart'; // Import the StepTracker class

class WalkScreen extends StatefulWidget {
  @override
  _WalkScreenState createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  final MapController _mapController = MapController();
  final List<LatLng> _path = [
    LatLng(41.9981, 21.4254), // Starting point in Skopje
    LatLng(41.9991, 21.4264), // Example point
    LatLng(42.0001, 21.4274), // Example point
  ];
  LatLng _currentLocation = LatLng(41.9981, 21.4254);

  // Variables to track duration and calories (steps will be fetched from StepTracker)
  Duration _duration = Duration(seconds: 0); // Starting duration at 0 seconds
  double _calories = 0.0;

  // Timer to simulate activity progression
  Timer? _timer;

  // Function to start the timer and update values
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration = Duration(seconds: _duration.inSeconds + 1); // Add 1 second to the duration
        _calories = (Provider.of<StepTracker>(context, listen: false).steps / 100) * 3.59; // Example calorie burn rate
      });
    });
  }

  // Function to stop the timer when not needed
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the timer when the screen is initialized
  }

  @override
  void dispose() {
    _stopTimer(); // Stop the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the StepTracker using the Provider
    final stepTracker = Provider.of<StepTracker>(context);

    return Scaffold(
      body: Column(
        children: [
          // Top Half - Map
          Expanded(
            flex: 3,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation,
                zoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _path,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bottom Half - Activity Details
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Steps and Metrics
                    Text(
                      "${stepTracker.steps} Steps", // Display steps from StepTracker
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_duration.inHours}h ${_duration.inMinutes % 60}m",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Duration",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_calories.toStringAsFixed(1)} kcal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Calories",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Graph
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          // Using fl_chart for graph
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, 3000),
                                      FlSpot(1, 4000),
                                      FlSpot(2, 6000),
                                      FlSpot(3, 8000),
                                    ],
                                    isCurved: true,
                                    color: Colors.blue,
                                    barWidth: 4,
                                    isStrokeCapRound: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Average",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Avg. 5303 steps",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Default to the "Walk" screen for navigation
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/'); // HomeScreen
          } else if (index == 1) {
            Navigator.pushNamed(context, '/workout'); // WorkoutSelectionScreen
          } else if (index == 2) {
            Navigator.pushNamed(context, '/session'); // WorkoutSessionScreen
          }
        },
        items: [
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
