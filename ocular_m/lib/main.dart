import 'package:flutter/material.dart';
// import 'views/weather_screen.dart';
// import 'views/todo_screen.dart';
import 'views/home_screen.dart';
void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WeatherScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utility App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,        // 🎨 App’s main theme color
        ),

      
      ),
      home: HomeScreen(),
    );
  }
}