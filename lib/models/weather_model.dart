import 'dart:ui';

class WeatherData {
  final String cityName;

  // Core weather
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;

  // Weather description
  final String weatherMain;
  final String weatherDescription;

  // Wind
  final double windSpeed;

  // Extras (NEW)
  final int cloudiness;      // %
  final int visibility;      // meters
  final DateTime sunrise;
  final DateTime sunset;

  // Meta
  final DateTime dateTime;
  final int precipitation; // mm (if available)

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.weatherMain,
    required this.weatherDescription,
    required this.windSpeed,
    required this.cloudiness,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.dateTime,
    required this.precipitation,
  });

  // ─────────────────────────────────────────────
  // JSON PARSER
  // ─────────────────────────────────────────────
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? 'Unknown',

      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      pressure: json['main']['pressure'] ?? 0,

      weatherMain: json['weather'][0]['main'] ?? 'Clear',
      weatherDescription: json['weather'][0]['description'] ?? '',

      windSpeed: (json['wind']['speed'] as num).toDouble(),

      cloudiness: json['clouds']?['all'] ?? 0,
      visibility: json['visibility'] ?? 0,

      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunrise'] ?? 0) * 1000,
        isUtc: true,
      ).toLocal(),

      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunset'] ?? 0) * 1000,
        isUtc: true,
      ).toLocal(),

      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
        isUtc: true,
      ).toLocal(),

      precipitation: json['rain'] != null
          ? (json['rain']['1h'] ?? 0).round()
          : 0,
    );
  }

  // ─────────────────────────────────────────────
  // UI HELPERS
  // ─────────────────────────────────────────────

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
    switch (getWeatherCondition()) {
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