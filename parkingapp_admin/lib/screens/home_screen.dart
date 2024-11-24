import 'package:flutter/material.dart';
import 'package:parkingapp_admin/screens/manage_parking_screen.dart';
import 'package:parkingapp_admin/screens/monitor_parking_screen.dart';
import 'package:parkingapp_admin/screens/overview_statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista över skärmar för varje navigationspunkt
  final List<Widget> _screens = [
    ManageParkingScreen(),
    MonitorParkingScreen(),
    OverviewStatisticsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.edit_location_alt),
                label: Text('Hantera Parkeringsplatser'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.monitor_heart),
                label: Text('Övervakning'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text('Statistik'),
              ),
            ],
          ),
          Expanded(
            child: _screens[_selectedIndex], // Visa vald skärm
          ),
        ],
      ),
    );
  }
}
