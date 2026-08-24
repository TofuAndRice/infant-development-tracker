import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/timeline_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const BabyLoggerApp()); 
}

class BabyLoggerApp extends StatelessWidget {
  const BabyLoggerApp({super.key}); 
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'Baby Logger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E5BFF), 
          primary: const Color(0xFF1E5BFF), 
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E49E8), 
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1E5BFF), 
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E5BFF),
            foregroundColor: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFC8D0DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF1E5BFF)),
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF8B96A8),
          ),
        ),
        useMaterial3: true,
      ),
      home: const TimelineScreen(), 
    );
  }
}
