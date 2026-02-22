import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import 'swipeup.dart';
class WeatherWidget extends StatefulWidget {
 final List<WeatherData> cities;
final int initialPage;
  final bool isDark;
  final Color textColor;
  final ValueChanged<int> onPageChanged;

  const WeatherWidget({
    super.key,
    required this.cities,
    required this.initialPage,
    required this.onPageChanged,
    required this.isDark,
    required this.textColor,
  });

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  int _verticalPageIndex = 0;
 late final PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _currentPage=widget.initialPage;
    _pageController=PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width=size.width;
    final h = height / 812; 
    final w = width / 375;
    return Column(
      children: [
        Expanded(
  child: PageView.builder(
    controller: _pageController,
    itemCount: widget.cities.length,
    onPageChanged: (index) {
      setState(() {_currentPage = index;
      
      });
      widget.onPageChanged(index);
    },
    itemBuilder: (context, index) {
      final city = widget.cities[index];

     return Stack(
  children: [
    PageView(
      scrollDirection: Axis.vertical,
      onPageChanged: (index){
        setState(() {
          _verticalPageIndex = index;
        });
      },
      children: [
        _buildMainWeatherView(height, city),
        _buildDetailedView(city),
      ],
    ),
    SwipeUpHint(
    isVisible: _verticalPageIndex == 0,
      color: widget.textColor,
    ),
  ],
);
    },
  ),
),
        _buildPageIndicator(),
        SizedBox(height: height * 0.025),
      ],
    );
  }

  Widget _buildMainWeatherView(double height,WeatherData weatherData) {
    final day = DateFormat('EEEE').format(weatherData.dateTime);
    final date = DateFormat('dd MMMM').format(weatherData.dateTime);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.01),
          Text(
            day,
            style: TextStyle(
              fontSize: height * 0.04,
              fontWeight: FontWeight.bold,
              color: widget.textColor.withOpacity(0.9),
              height: 1.3,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          SizedBox(height: height * 0.008),
          Text(
            date,
            style: TextStyle(
              fontSize: height * 0.03,
              fontWeight: FontWeight.w400,
              color: widget.textColor.withOpacity(0.9),
              height: 1.3,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),

          SizedBox(height: height * 0.04),
          Container(
            width: double.infinity,
            height: 5,
            color: widget.textColor,
          ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),
          SizedBox(height: height * 0.09),
          Text(
                '${weatherData.temperature.round()}°',
                style: TextStyle(
                  fontSize: 140,
                  fontWeight: FontWeight.w300,
                  color: widget.textColor,
                  height: 0.9,
                  letterSpacing: -4,
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                duration: 600.ms,
                delay: 400.ms,
              ),

          SizedBox(height: height * 0.01),

          // Weather condition
          Text(weatherData.getWeatherCondition(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: widget.textColor.withOpacity(0.85),
              letterSpacing: 0.5,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 800.ms),

          SizedBox(height: height * 0.1),

          Container(
            width: double.infinity,
            height: 5,
            color: widget.textColor,
          ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),

          SizedBox(height: height * 0.06),

          // Additional info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                '${weatherData.temperature.round()}°C',
                 weatherData.weatherDescription,
                height
              ),
              _buildInfoItem(
                '${weatherData.humidity}%',
                '${weatherData.windSpeed.round()} km/h Wind',
                height
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),
        ],
      ),
    );
  }

Widget _buildDetailedView(WeatherData weatherData) {
  final weather = weatherData;
  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: widget.textColor,
          ),
        ),
        Text(
          DateFormat('E, dd MMM').format(weather.dateTime),
          style: TextStyle(
            fontSize: 16,
            color: widget.textColor.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 25),
        Container(
          width: double.infinity,
          height: 4,
          color: widget.textColor,
        ),

        const SizedBox(height: 48),

        Text(
          '${weather.humidity}%',
          style: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w600,
            color: widget.textColor,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Humidity',
          style: TextStyle(
            fontSize: 18,
            color: widget.textColor.withOpacity(0.7),
          ),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temperature.round()}°C',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.textColor,
                  ),
                ),
                Text(
                  'Feels like ${weather.feelsLike.round()}°C',
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${weather.windSpeed.round()} km/h',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.textColor,
                  ),
                ),
                Text(
                  weather.weatherDescription,
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 32),
        Divider(color: widget.textColor, thickness: 4),
        const SizedBox(height: 24),

        Wrap(
          spacing: 24,
          runSpacing: 20,
          children: [
            _detailItem('Clouds', '${weather.cloudiness}%'),
            _detailItem('Pressure', '${weather.pressure} hPa'),
            _detailItem('Visibility', '${weather.visibility ~/ 1000} km'),
            _detailItem(
              'Sunrise',
              DateFormat('HH:mm').format(weather.sunrise),
            ),
            _detailItem(
              'Sunset',
              DateFormat('HH:mm').format(weather.sunset),
            ),
          ],
        ),
      ],
    ),
  ).animate().fadeIn(duration: 600.ms);
}
Widget _detailItem(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
    ],
  );
}

  Widget _buildInfoItem(String title, String subtitle,double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize:height*0.04 ,
            fontWeight: FontWeight.w500,
            color: widget.textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: widget.textColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.cities.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 45 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? widget.textColor
                : widget.textColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }).animate(interval: 50.ms).fadeIn(duration: 400.ms),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
