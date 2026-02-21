import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tempora/clock.dart';
import 'package:tempora/navbar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tempora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE8E8E8),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage>
    with SingleTickerProviderStateMixin {
  DateTime _currentTime = DateTime.now();
  bool _is24Hour = true;
  Timer? _timer;
  int _selectedIndex = 1;
  String temperature = "";
  String weatherDescription = "";

  String location = "Loading...";
  late AnimationController _slideController;
  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    getlocation();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _slideController.forward(from: 0.0);
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> getlocation() async {
    bool serviceenabled;
    LocationPermission p;
    serviceenabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceenabled) {
      setState(() {
        location = "Allow location";
      });
      return;
    }

    p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied) {
        setState(() {
          location = "Permission denied";
        });
        return;
      }
    }

    Position pos = await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
      ),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    await getWeatherData(pos.latitude, pos.longitude);
    Placemark place = placemarks[0];
    setState(() {
      location =
          "${place.locality},\n${place.administrativeArea},\n${place.country}";
    });
  }

  Future<void> getWeatherData(double lat, double lon) async {
    const String apiKey = '2674e700ce2cd26418f27c4fa30ccefb';
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          temperature = "${data['main']['temp'].round()}°C";
          weatherDescription = data['weather'][0]['description'];
        });
      } else {
        print("Weather API error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  String _getFormattedHour() {
    if (_is24Hour) {
      return _currentTime.hour.toString().padLeft(2, '0');
    } else {
      int hour = _currentTime.hour % 12;
      if (hour == 0) hour = 12;
      return hour.toString().padLeft(2, '0');
    }
  }

  String _getFormattedMinute() {
    return _currentTime.minute.toString().padLeft(2, '0');
  }

  String _getFormattedSecond() {
    return _currentTime.second.toString().padLeft(2, '0');
  }

  String _getPreviousSecond() {
    int prevSecond = (_currentTime.second - 1) % 60;
    if (prevSecond < 0) prevSecond = 59;
    return prevSecond.toString().padLeft(2, '0');
  }

  String _getNextSecond() {
    int nextSecond = (_currentTime.second + 1) % 60;
    return nextSecond.toString().padLeft(2, '0');
  }

  String _getWeekday() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[_currentTime.weekday - 1];
  }

  String _getFormattedDate() {
    return '${_currentTime.day} ${_getMonthName()}';
  }

  String _getMonthName() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[_currentTime.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizing
    final clockFontSize = screenWidth * 0.38;
    final dateFontSize = screenWidth * 0.10;
    final secondsFontSize = screenWidth * 0.17;
    final locationFontSize = screenWidth * 0.115;
    final horizontalPadding = screenWidth * 0.08;

    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.circle, // 👈 makes it round
              ),
              child: NavButton(
                icon: Icons.search,
                isActive: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.circle,
              ),
              child: NavButton(
                icon: Icons.timelapse,
                isActive: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.circle,
              ),
              child: NavButton(
                icon: Icons.language,
                isActive: _selectedIndex == 2,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorldClockPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with icon and toggle
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left icon
                  Container(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    child: Icon(
                      Icons.sunny,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                  ),
                  // 12h/24h toggle
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _is24Hour = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: !_is24Hour
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.05,
                            ),
                          ),
                          child: Text(
                            '12h',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: !_is24Hour ? Colors.black : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _is24Hour = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: _is24Hour
                                ? Colors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.05,
                            ),
                          ),
                          child: Text(
                            '24h',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w800,
                              color: _is24Hour ? Colors.white : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Main clock display
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Clock and date row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hour and minute
                          Text(
                            '${_getFormattedHour()}\n${_getFormattedMinute()}',
                            style: GoogleFonts.inter(
                              fontSize: clockFontSize,
                              fontWeight: FontWeight.w700,
                              height: 0.95,
                              letterSpacing: -3,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          // Weekday, date, and seconds
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Weekday
                                Text(
                                  '${_getWeekday()},',
                                  style: GoogleFonts.inter(
                                    fontSize: dateFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // Date
                                Text(
                                  _getFormattedDate(),
                                  style: GoogleFonts.inter(
                                    fontSize: dateFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.09),
                                Text(
                                  _getFormattedSecond(),
                                  style: GoogleFonts.inter(
                                    fontSize: secondsFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Location
                      Text(
                        location,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: locationFontSize,
                          fontWeight: FontWeight.w300,
                          height: 1.1,
                          letterSpacing: 0,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Weather info
                      // Weather info
                      if (temperature.isNotEmpty &&
                          weatherDescription.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wb_sunny_outlined,
                                size: screenWidth * 0.07,
                                color: Colors.orange,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                '$temperature | ${weatherDescription[0].toUpperCase()}${weatherDescription.substring(1)}',
                                style: GoogleFonts.inter(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
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
      ),
    );
  }
}