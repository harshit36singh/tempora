import 'dart:async';

import 'package:flutter/material.dart';

class WorldClockPage extends StatefulWidget {
  const WorldClockPage({super.key});

  @override
  State<WorldClockPage> createState() => _WorldClockPageState();
}

class _WorldClockPageState extends State<WorldClockPage> {
  late Timer _timer;
  DateTime now = DateTime.now();

  final List<Map<String, dynamic>> cities = [
    {"name": "New York", "offset": -4},
    {"name": "London", "offset": 0},
    {"name": "Paris", "offset": 1},
    {"name": "Dubai", "offset": 4},
    {"name": "Tokyo", "offset": 9},
    {"name": "Sydney", "offset": 11},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("World Clock"),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final time = now.toUtc().add(Duration(hours: city["offset"]));
          return ListTile(
            leading: const Icon(Icons.language, color: Colors.deepPurpleAccent),
            title: Text(
              city["name"],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              formatTime(time),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}
