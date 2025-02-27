import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const BrasaTourApp());

class BrasaTourApp extends StatelessWidget {
  const BrasaTourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrasaTour',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}