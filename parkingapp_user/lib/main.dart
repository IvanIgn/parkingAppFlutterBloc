import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkeringsApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //darkTheme: ThemeData.dark(),
      //themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
