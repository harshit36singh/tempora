import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WeatherWidget extends StatefulWidget {
  final WeatherData weatherData;
  final bool isDark;
  final Color textColor;

  const WeatherWidget({
    super.key,
    required this.weatherData,
    required this.isDark,
    required this.textColor,
  });

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildMainWeatherView(height),
              _buildDetailedView(),
              _buildWidgetView(),
            ],
          ),
        ),
        _buildPageIndicator(),
        SizedBox(height: height * 0.025),
      ],
    );
  }

  Widget _buildMainWeatherView(double height) {
    final day = DateFormat('EEEE').format(widget.weatherData.dateTime);
    final date = DateFormat('dd MMMM').format(widget.weatherData.dateTime);

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
                '${widget.weatherData.temperature.round()}°',
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
          Text(
            widget.weatherData.getWeatherCondition(),
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
                '${widget.weatherData.temperature.round()}°C',
                'Feels like ${widget.weatherData.feelsLike.round()}°C',
                height
              ),
              _buildInfoItem(
                '${widget.weatherData.humidity}%',
                '${widget.weatherData.windSpeed.round()} km/h Wind',
                height
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),
        ],
      ),
    );
  }

  Widget _buildDetailedView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Today',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: widget.textColor,
            ),
          ),
          Text(
            DateFormat('E, dd MMM').format(widget.weatherData.dateTime),
            style: TextStyle(
              fontSize: 16,
              color: widget.textColor.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 2,
            color: widget.textColor.withOpacity(0.2),
          ),

          const SizedBox(height: 60),

          // Rain probability
          Text(
            '${widget.weatherData.humidity}%',
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rain probability',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: widget.textColor.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 60),

          Container(
            width: double.infinity,
            height: 1,
            color: widget.textColor.withOpacity(0.15),
          ),

          const SizedBox(height: 24),

          // Weather details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.weatherData.temperature.round()}°C',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                    ),
                  ),
                  Text(
                    'Feels like ${widget.weatherData.feelsLike.round()}°C',
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
                    '${widget.weatherData.windSpeed.round()} km/h',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                    ),
                  ),
                  Text(
                    'Light wind',
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildWidgetView() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.weatherData.cityName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: widget.textColor.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${widget.weatherData.humidity}%',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w600,
                        color: widget.textColor,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Chance of rain',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: widget.textColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: widget.textColor.withOpacity(0.15),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${widget.weatherData.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: widget.textColor,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95), duration: 500.ms),
        ],
      ),
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
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 20 : 6,
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
