import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  static String apiKey = dotenv.env['OPEN_WEATHER_API_KEY']!;
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherData> getWeatherByLocation() async {
    try {
      final position = await getCurrentLocation();
      return await getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  Future<WeatherData> getWeatherByCoordinates(
      double lat, double lon) async {
    try {
      final url = Uri.parse(
          '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  Future<WeatherData> getWeatherByCity(String cityName) async {
    try {
      final url = Uri.parse(
          '$baseUrl?q=$cityName&appid=$apiKey&units=metric');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}