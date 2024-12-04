import 'package:flutter/material.dart';
import 'package:parkingapp_user/views/login_view.dart';
import 'package:parkingapp_user/views/vehicle_management_view.dart';
import 'package:parkingapp_user/views/parkingplace_selection_view.dart';
import 'package:parkingapp_user/views/active_parking_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista över skärmar för varje navigationspunkt
  final List<Widget> _screens = [
    const LoginScreen(),
    const VehicleManagementScreen(),
    const ParkingSpaceSelectionScreen(),
    const ActiveParkingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ParkeringsApp"),
      ),
      body: _screens[_selectedIndex], // Byt innehåll baserat på valt index
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Inloggning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Fordon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Parkeringsplats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Aktiva Parkeringar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 64, 63, 63),
        onTap: _onItemTapped,
      ),
    );
  }
}
