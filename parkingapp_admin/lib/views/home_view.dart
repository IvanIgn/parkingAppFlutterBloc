// import 'package:flutter/material.dart';
// import 'package:parkingapp_admin/views/manage_parkingspaces_view.dart'
//     as manage;
// import 'package:parkingapp_admin/views/monitor_parking_view.dart' as monitor;
// import 'package:parkingapp_admin/views/overview_statistics_view.dart'
//     as overview;
// import 'package:parkingapp_admin/views/manage_persons_view.dart' as manage;
// import 'package:parkingapp_admin/views/manage_vehicles_view.dart' as manage;
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final List<bool> _isHovered = [
//     false,
//     false,
//     false,
//     false,
//     false
//   ]; // Track hover states for each button

//   // List of screens for each navigation item
//   final List<Widget> _screens = [
//     const manage.ManagePersonsView(),
//     const manage.ManageVehiclesView(),
//     const manage.ManageParkingSpacesView(),
//     const monitor.MonitorParkingsView(),
//     const overview.OverviewStatisticsView(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           NavigationRail(
//             selectedIndex: _selectedIndex,
//             onDestinationSelected: _onItemTapped,
//             labelType: NavigationRailLabelType.all,
//             destinations: [
//               _buildNavigationRailDestination(
//                 index: 0,
//                 icon: Icons.person,
//                 label: 'Hantera Personer',
//               ),
//               _buildNavigationRailDestination(
//                 index: 1,
//                 icon: Icons.directions_car,
//                 label: 'Hantera Fordoner',
//               ),
//               _buildNavigationRailDestination(
//                 index: 2,
//                 icon: Icons.edit_location_alt,
//                 label: 'Hantera Parkeringsplatser',
//               ),
//               _buildNavigationRailDestination(
//                 index: 3,
//                 icon: Icons.local_parking,
//                 label: 'Övervakning',
//               ),
//               _buildNavigationRailDestination(
//                 index: 4,
//                 icon: Icons.bar_chart,
//                 label: 'Statistik',
//               ),
//             ],
//           ),
//           Expanded(
//             child: _screens[_selectedIndex], // Show the selected screen
//           ),
//         ],
//       ),
//     );
//   }

//   NavigationRailDestination _buildNavigationRailDestination({
//     required int index,
//     required IconData icon,
//     required String label,
//   }) {
//     return NavigationRailDestination(
//       icon: MouseRegion(
//         onEnter: (_) {
//           setState(() {
//             _isHovered[index] = true;
//           });
//         },
//         onExit: (_) {
//           setState(() {
//             _isHovered[index] = false;
//           });
//         },
//         child: Icon(
//           icon,
//           color: _isHovered[index] || _selectedIndex == index
//               ? Colors.blue
//               : const Color.fromARGB(255, 64, 63, 63),
//         ),
//       ),
//       label: MouseRegion(
//         onEnter: (_) {
//           setState(() {
//             _isHovered[index] = true;
//           });
//         },
//         onExit: (_) {
//           setState(() {
//             _isHovered[index] = false;
//           });
//         },
//         child: Text(
//           label,
//           style: TextStyle(
//             color: _isHovered[index] || _selectedIndex == index
//                 ? Colors.blue
//                 : const Color.fromARGB(255, 64, 63, 63),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:parkingapp_admin/views/manage_parkingspaces_view.dart'
    as parkingspaces;
import 'package:parkingapp_admin/views/monitor_parking_view.dart' as monitor;
import 'package:parkingapp_admin/views/overview_statistics_view.dart'
    as overview;
import 'package:parkingapp_admin/views/manage_persons_view.dart' as persons;
import 'package:parkingapp_admin/views/manage_vehicles_view.dart' as vehicles;

import 'package:parkingapp_admin/views/settings_view.dart' as settings;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Map<int, bool> _isHovered = {}; // Track hover states for each button

  // List of screens for each navigation item
  final List<Widget> _screens = [
    const persons.ManagePersonsView(),
    const vehicles.ManageVehiclesView(),
    const parkingspaces.ManageParkingSpacesView(),
    const monitor.MonitorParkingsView(),
    const overview.OverviewStatisticsView(),
    const settings.SettingsView(),
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
                icon: Icons.person,
                label: 'Hantera Personer',
              ),
              _buildNavigationRailDestination(
                index: 1,
                icon: Icons.directions_car,
                label: 'Hantera Fordoner',
              ),
              _buildNavigationRailDestination(
                index: 2,
                icon: Icons.edit_location_alt,
                label: 'Hantera Parkeringsplatser',
              ),
              _buildNavigationRailDestination(
                index: 3,
                icon: Icons.local_parking,
                label: 'Övervakning',
              ),
              _buildNavigationRailDestination(
                index: 4,
                icon: Icons.bar_chart,
                label: 'Statistik',
              ),
              _buildNavigationRailDestination(
                index: 5,
                icon: Icons.settings,
                label: 'Settings',
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
          color: _isHovered[index] == true || _selectedIndex == index
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
            color: _isHovered[index] == true || _selectedIndex == index
                ? Colors.blue
                : const Color.fromARGB(255, 64, 63, 63),
          ),
        ),
      ),
    );
  }
}
