import 'package:flutter/material.dart';
// import 'views/weather_screen.dart';
// import 'views/todo_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/home_screen.dart';
void main() {
  // 👇 VERY IMPORTANT: wrap app in ProviderScope
  runApp(const ProviderScope(child: MyApp()));
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
        scaffoldBackgroundColor: Color(0xaa222f3e),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xaa1dd1a1),        // 🎨 App’s main theme color
        ),

      
      ),
      home: HomeScreen(),
    );
  }
}