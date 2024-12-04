import 'package:flutter/material.dart';
//import 'package:parkingapp_user/widgets/navbar_widget.dart';

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
      home: const HomeScreen(),
    );
  }
}
