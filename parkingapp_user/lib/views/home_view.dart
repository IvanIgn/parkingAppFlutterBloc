import 'package:flutter/material.dart';
import 'package:parkingapp_user/views/login_view.dart';
import 'package:parkingapp_user/views/vehicle_management_view.dart';
import 'package:parkingapp_user/views/parkingplace_selection_view.dart';
import 'package:parkingapp_user/views/active_parking_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoggedIn = false; // Authentication state

  // All available screens
  late List<Widget> _views;

  @override
  void initState() {
    super.initState();
    _views = [
      LoginView(onLoginSuccess: _onLoginSuccess),
      const VehicleManagementView(),
      const ParkingSpaceSelectionScreen(),
      const ActiveParkingScreen(),
    ];
  }

  // Callback for successful login
  void _onLoginSuccess() {
    setState(() {
      isLoggedIn = true;
      _selectedIndex = 1; // Redirect to the first main screen post-login
      //_views[0] = const SizedBox.shrink(); // Make LoginView inactive
    });
  }

  void _onItemTapped(int index) {
    if (isLoggedIn || index == 0) {
      // Allow access to LoginScreen anytime
      setState(() {
        _selectedIndex = index;
        //_views.remove(0); // Remove LoginView after successful login
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Logga in för att komma åt detta informationsflöde")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ParkeringsApp"),
      ),
      body: isLoggedIn
          ? _views[_selectedIndex]
          : LoginView(
              onLoginSuccess:
                  _onLoginSuccess), // Show LoginScreen if not logged in
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
