import 'dart:ui';

class WeatherData {
  final String cityName;
  final double temperature;
  final String weatherMain;
  final String weatherDescription;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime dateTime;
  final int precipitation;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.weatherMain,
    required this.weatherDescription,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.dateTime,
    required this.precipitation,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      weatherMain: json['weather'][0]['main'] ?? 'Clear',
      weatherDescription: json['weather'][0]['description'] ?? '',
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      precipitation: json['rain'] != null ? (json['rain']['1h'] ?? 0) : 0,
    );
  }

  String getWeatherCondition() {
    if (weatherMain.contains('Rain') || weatherMain.contains('Drizzle')) {
      return 'Rainy';
    } else if (weatherMain.contains('Cloud')) {
      return 'Cloudy';
    } else if (weatherMain.contains('Clear')) {
      return 'Sunny';
    } else if (weatherMain.contains('Snow')) {
      return 'Snowy';
    } else if (weatherMain.contains('Thunder')) {
      return 'Stormy';
    }
    return 'Clear';
  }

  Color getThemeColor() {
    final condition = getWeatherCondition();
    switch (condition) {
      case 'Sunny':
        return const Color(0xFFFDD835);
      case 'Rainy':
      case 'Cloudy':
        return const Color(0xFFE8E8E8);
      case 'Stormy':
        return const Color(0xFF1A237E);
      case 'Snowy':
        return const Color(0xFFE3F2FD);
      default:
        return const Color(0xFFE8E8E8);
    }
  }

  bool isDarkTheme() {
    return getWeatherCondition() == 'Stormy';
  }
}