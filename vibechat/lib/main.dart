import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Vibe Chat",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          //Ek baar app bar ka theme decide krna padega bass
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 19,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
