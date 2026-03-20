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
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isTablet = width > 600;
    final isLargeTablet = width > 900;

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.cities.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              widget.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              final city = widget.cities[index];

              return Stack(
                children: [
                  PageView(
                    scrollDirection: Axis.vertical,
                    onPageChanged: (idx) {
                      setState(() {
                        _verticalPageIndex = idx;
                      });
                    },
                    children: [
                      _buildMainWeatherView(size, city, isTablet, isLargeTablet),
                      _buildDetailedView(city, size, isTablet, isLargeTablet),
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
        _buildPageIndicator(size),
        SizedBox(height: height * 0.025),
      ],
    );
  }

  Widget _buildMainWeatherView(
      Size size, WeatherData weatherData, bool isTablet, bool isLargeTablet) {
    final height = size.height;
    final width = size.width;

    final day = DateFormat('EEEE').format(weatherData.dateTime);
    final date = DateFormat('dd MMMM').format(weatherData.dateTime);

    // Responsive font sizes
    final dayFontSize = isLargeTablet
        ? height * 0.055
        : isTablet
            ? height * 0.048
            : height * 0.04;
    final dateFontSize = isLargeTablet
        ? height * 0.04
        : isTablet
            ? height * 0.035
            : height * 0.03;
    final tempFontSize = isLargeTablet ? 180.0 : isTablet ? 160.0 : 140.0;
    final infoFontSize = isLargeTablet
        ? height * 0.05
        : isTablet
            ? height * 0.045
            : height * 0.04;

    final hPadding = isLargeTablet
        ? width * 0.12
        : isTablet
            ? width * 0.08
            : 32.0;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.01),
          Text(
            day,
            style: TextStyle(
              fontSize: dayFontSize,
              fontWeight: FontWeight.bold,
              color: widget.textColor.withOpacity(0.9),
              height: 1.3,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),

          SizedBox(height: height * 0.008),

          Text(
            date,
            style: TextStyle(
              fontSize: dateFontSize,
              fontWeight: FontWeight.w400,
              color: widget.textColor.withOpacity(0.9),
              height: 1.3,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),

          SizedBox(height: height * 0.04),

          Container(
            width: double.infinity,
            height: isTablet ? 6 : 5,
            color: widget.textColor,
          ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),

          SizedBox(height: height * 0.09),

          Text(
            '${weatherData.temperature.round()}°',
            style: TextStyle(
              fontSize: tempFontSize,
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

          Text(
            weatherData.getWeatherCondition(),
            style: TextStyle(
              fontSize: isTablet ? 26 : 22,
              fontWeight: FontWeight.w400,
              color: widget.textColor.withOpacity(0.85),
              letterSpacing: 0.5,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 800.ms),

          SizedBox(height: height * 0.1),

          Container(
            width: double.infinity,
            height: isTablet ? 6 : 5,
            color: widget.textColor,
          ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),

          SizedBox(height: height * 0.06),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                '${weatherData.temperature.round()}°C',
                weatherData.weatherDescription,
                infoFontSize,
              ),
              _buildInfoItem(
                '${weatherData.humidity}%',
                '${weatherData.windSpeed.round()} km/h Wind',
                infoFontSize,
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),

          SizedBox(height: height * 0.04),
        ],
      ),
    );
  }

  Widget _buildDetailedView(
      WeatherData weatherData, Size size, bool isTablet, bool isLargeTablet) {
    final height = size.height;
    final width = size.width;
    final weather = weatherData;

    final hPadding = isLargeTablet
        ? width * 0.12
        : isTablet
            ? width * 0.08
            : 32.0;

    final humidityFontSize =
        isLargeTablet ? 120.0 : isTablet ? 108.0 : 96.0;
    final titleFontSize = isLargeTablet ? 36.0 : isTablet ? 32.0 : 28.0;
    final subtitleFontSize = isLargeTablet ? 18.0 : isTablet ? 17.0 : 16.0;
    final bodyFontSize = isLargeTablet ? 16.0 : isTablet ? 15.0 : 13.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hPadding, 0, hPadding, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w400,
              color: widget.textColor,
            ),
          ),
          Text(
            DateFormat('E, dd MMM').format(weather.dateTime),
            style: TextStyle(
              fontSize: bodyFontSize + 2,
              color: widget.textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: height * 0.03),
          Container(
            width: double.infinity,
            height: isTablet ? 5 : 4,
            color: widget.textColor,
          ),
          SizedBox(height: height * 0.06),
          Text(
            '${weather.humidity}%',
            style: TextStyle(
              fontSize: humidityFontSize,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Humidity',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: widget.textColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temperature.round()}°C',
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                    ),
                  ),
                  Text(
                    'Feels like ${weather.feelsLike.round()}°C',
                    style: TextStyle(
                      fontSize: bodyFontSize,
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
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                    ),
                  ),
                  Text(
                    weather.weatherDescription,
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      color: widget.textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.04),
          Divider(color: widget.textColor, thickness: isTablet ? 5 : 4),
          SizedBox(height: height * 0.03),
          Wrap(
            spacing: isTablet ? 40 : 24,
            runSpacing: isTablet ? 28 : 20,
            children: [
              _detailItem('Clouds', '${weather.cloudiness}%',
                  subtitleFontSize, bodyFontSize),
              _detailItem('Pressure', '${weather.pressure} hPa',
                  subtitleFontSize, bodyFontSize),
              _detailItem(
                  'Visibility',
                  '${weather.visibility ~/ 1000} km',
                  subtitleFontSize,
                  bodyFontSize),
              _detailItem(
                  'Sunrise',
                  DateFormat('HH:mm').format(weather.sunrise),
                  subtitleFontSize,
                  bodyFontSize),
              _detailItem(
                  'Sunset',
                  DateFormat('HH:mm').format(weather.sunset),
                  subtitleFontSize,
                  bodyFontSize),
            ],
          ),
          SizedBox(height: height * 0.04),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _detailItem(
      String title, String value, double valueFontSize, double titleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w500,
            color: widget.textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            color: widget.textColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String subtitle, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: widget.textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: fontSize * 0.65,
            color: widget.textColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(Size size) {
    final isTablet = size.width > 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.cities.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: isTablet ? 6 : 4),
          width: _currentPage == index ? (isTablet ? 56 : 45) : (isTablet ? 8 : 6),
          height: isTablet ? 8 : 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? widget.textColor
                : widget.textColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(isTablet ? 4 : 3),
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