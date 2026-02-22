import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const TemporaApp());
}

class TemporaApp extends StatelessWidget {
  const TemporaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFE8E8E8),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}