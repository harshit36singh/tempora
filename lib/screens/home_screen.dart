import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final List<WeatherData> _cities = [];
  int _currentCityIndex = 0;
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  _initApp();
  }
  
  LinearGradient getWeatherDialogGradient(WeatherData? weather, bool isDark) {
  final condition = weather?.getWeatherCondition() ?? 'Clear';

  switch (condition) {
    case 'Sunny':
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFF3C0),
          Color(0xFFFFE082),
        ],
      );

    case 'Rainy':
    case 'Cloudy':
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE6E6E6),
          Color(0xFFCBCBCB),
        ],
      );

    case 'Stormy':
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2A2E4D),
          Color(0xFF1C1F36),
        ],
      );

    case 'Snowy':
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF5FAFF),
          Color(0xFFE3F2FD),
        ],
      );

    default:
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xFF2A2E4D), const Color(0xFF1F223A)]
            : [const Color(0xFFF7F7F7), const Color(0xFFEDEDED)],
      );
  }
}
  Future<void> _initApp() async {
  try {
    await _loadSavedCities();

    if (_cities.isEmpty) {
      await _loadWeather();
    }
  } catch (e) {
    _error = e.toString();
  }

  if (!mounted) return;

  setState(() {
    _isLoading = false;
  });
}

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getWeatherByLocation();
      setState(() {
        
        _cities.add(weather);
        _currentCityIndex = 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  Future<void> _savecities()async{
    final pref=await SharedPreferences.getInstance();
    final citynames=_cities.map((c)=>c.cityName).toList();
    await pref.setStringList("saved_cities", citynames);
  }
 Future<void> _loadSavedCities() async {
  final prefs = await SharedPreferences.getInstance();
  final cityNames = prefs.getStringList('saved_cities') ?? [];

  final loadedCities = <WeatherData>[];

  for (final city in cityNames) {
    try {
      final weather = await _weatherService.getWeatherByCity(city);
      loadedCities.add(weather);
    } catch (_) {}
  }

  if (!mounted) return;

  setState(() {
    _cities.addAll(loadedCities);
    _currentCityIndex = 0;
  });
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
        _cities.add(weather);
        _currentCityIndex = _cities.length - 1;
        _isLoading = false;
      });
      await _savecities();
      
    } catch (e) {
      setState(() {
        _error = 'City not found';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCity =
    _cities.isNotEmpty ? _cities[_currentCityIndex] : null;
 final backgroundColor =
    currentCity?.getThemeColor() ?? const Color(0xFFE8E8E8);
    final isDark = currentCity?.isDarkTheme() ?? false;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(color: backgroundColor),
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
                    : _cities.isNotEmpty
                    ? WeatherWidget(
                        cities: _cities,
                        initialPage: _currentCityIndex,
                        isDark: isDark,
                        textColor: textColor,
                        onPageChanged: (index){
                          setState(() {
                            _currentCityIndex=index;
                          });
                        },
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
          SizedBox(
            width: 48,
            height: 48,
            child: Material(
              color: Colors.transparent,
              child: InkResponse(
                radius: 28,
                onTap: () {
                  debugPrint('Menu tapped');
                },
                child: Center(
                  child: Image.asset(
                    'assets/inappicon.png',
                    width: 45,
                    height: 45,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),

          // CITY NAME
          Text(
            _cities.isNotEmpty?
            _cities[_currentCityIndex].cityName.toUpperCase():'LOADING',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ).animate().fadeIn(duration: 400.ms),

          // SEARCH BUTTON (keep IconButton if you want)
          IconButton(
            icon: Icon(Icons.add, color: textColor),
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
          Icon(
            Icons.error_outline,
            size: 48,
            color: textColor.withOpacity(0.5),
          ),
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
  final currentWeather =
      _cities.isNotEmpty ? _cities[_currentCityIndex] : null;

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),

      child: Container(
        padding: const EdgeInsets.all(24),

        // 🌦 WEATHER-BASED GRADIENT
        decoration: BoxDecoration(
          gradient: getWeatherDialogGradient(currentWeather, isDark),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add City',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              cursorColor: textColor,
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

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: textColor.withOpacity(0.7),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: textColor),
                  onPressed: () {
                    Navigator.pop(context);
                    _searchCity(_searchController.text);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
