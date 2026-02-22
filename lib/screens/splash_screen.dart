import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'tempora',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
                color: Colors.black.withOpacity(0.85),
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 200.ms)
                .scale(begin: const Offset(0.8, 0.8), delay: 200.ms),
            const SizedBox(height: 12),
            Text(
              'weather in the moment',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                color: Colors.black.withOpacity(0.4),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}