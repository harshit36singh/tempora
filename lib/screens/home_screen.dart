import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getWeatherByLocation();
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchCity(String cityName) async {
    if (cityName.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCity(cityName);
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'City not found';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _weatherData?.getThemeColor() ?? const Color(0xFFE8E8E8);
    final isDark = _weatherData?.isDarkTheme() ?? false;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(isDark, textColor),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: textColor.withOpacity(0.5),
                        ),
                      )
                    : _error != null
                        ? _buildError(textColor)
                        : _weatherData != null
                            ? WeatherWidget(
                                weatherData: _weatherData!,
                                isDark: isDark,
                                textColor: textColor,
                              )
                            : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: textColor),
            onPressed: () {},
          ),
          Text(
            _weatherData?.cityName.toUpperCase() ?? 'LOADING',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ).animate().fadeIn(duration: 400.ms),
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () => _showSearchDialog(isDark, textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildError(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: textColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            style: TextStyle(color: textColor.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadWeather,
            style: ElevatedButton.styleFrom(
              backgroundColor: textColor.withOpacity(0.1),
              foregroundColor: textColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(bool isDark, Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2A2E4D) : Colors.white,
        title: Text(
          'Search City',
          style: TextStyle(color: textColor),
        ),
        content: TextField(
          controller: _searchController,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Enter city name',
            hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: textColor.withOpacity(0.3)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: textColor),
            ),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            _searchCity(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: textColor.withOpacity(0.7))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchCity(_searchController.text);
            },
            child: Text('Search', style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}