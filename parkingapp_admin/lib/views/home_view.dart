import 'package:flutter/material.dart';
import 'package:parkingapp_admin/views/manage_parkingspaces_view.dart'
    as manage;
import 'package:parkingapp_admin/views/monitor_parking_view.dart' as monitor;
import 'package:parkingapp_admin/views/overview_statistics_view.dart'
    as overview;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<bool> _isHovered = [
    false,
    false,
    false
  ]; // Track hover states for each button

  // List of screens for each navigation item
  final List<Widget> _screens = [
    const manage.ManageParkingSpacesView(),
    const monitor.MonitorParkingsView(),
    const overview.OverviewStatisticsView(),
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
            destinations: [
              _buildNavigationRailDestination(
                index: 0,
                icon: Icons.edit_location_alt,
                label: 'Hantera Parkeringsplatser',
              ),
              _buildNavigationRailDestination(
                index: 1,
                icon: Icons.monitor_heart,
                label: 'Övervakning',
              ),
              _buildNavigationRailDestination(
                index: 2,
                icon: Icons.bar_chart,
                label: 'Statistik',
              ),
            ],
          ),
          Expanded(
            child: _screens[_selectedIndex], // Show the selected screen
          ),
        ],
      ),
    );
  }

  NavigationRailDestination _buildNavigationRailDestination({
    required int index,
    required IconData icon,
    required String label,
  }) {
    return NavigationRailDestination(
      icon: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered[index] = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered[index] = false;
          });
        },
        child: Icon(
          icon,
          color: _isHovered[index] || _selectedIndex == index
              ? Colors.blue
              : const Color.fromARGB(255, 64, 63, 63),
        ),
      ),
      label: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered[index] = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered[index] = false;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            color: _isHovered[index] || _selectedIndex == index
                ? Colors.blue
                : const Color.fromARGB(255, 64, 63, 63),
          ),
        ),
      ),
    );
  }
}
