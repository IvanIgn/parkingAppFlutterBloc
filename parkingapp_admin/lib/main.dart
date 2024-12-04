import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() {
  runApp(const ParkingAdminApp());
}

class ParkingAdminApp extends StatelessWidget {
  const ParkingAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
