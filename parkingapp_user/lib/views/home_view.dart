// import 'package:flutter/material.dart';
// import 'package:parkingapp_user/views/login_view.dart';
// import 'package:parkingapp_user/views/vehicle_management_view.dart';
// import 'package:parkingapp_user/views/parkingplace_selection_view.dart';
// import 'package:parkingapp_user/views/active_parking_view.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0; // Start at the second view
//   bool isLoggedIn = false; // Authentication state

//   // All available screens
//   late List<Widget> _views;

//   @override
//   void initState() {
//     super.initState();
//     _views = [
//       LoginView(onLoginSuccess: _onLoginSuccess),
//       const VehicleManagementView(),
//       const ParkingSpaceSelectionScreen(),
//       const ActiveParkingScreen(),
//     ];
//   }

//   // Callback for successful login
//   void _onLoginSuccess() {
//     setState(() {
//       isLoggedIn = true;
//       _selectedIndex = 1; // Automatically switch to the second view
//       _views[0] = const SizedBox.shrink(); // Remove LoginView
//     });
//   }

//   // Show logout confirmation dialog
//   Future<void> _showLogoutConfirmation() async {
//     final shouldLogout = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Bekräfta utloggning"),
//           content: const Text("Vill du logga ut?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false), // Cancel
//               child: const Text("Avbryt"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true), // Confirm
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );

//     if (shouldLogout == true) {
//       _onExitTapped();
//     }
//   }

//   void _onExitTapped() {
//     setState(() {
//       isLoggedIn = false;
//       _selectedIndex = 0; // Redirect to the login view
//       _views[0] =
//           LoginView(onLoginSuccess: _onLoginSuccess); // Restore LoginView
//     });
//   }

//   void _onItemTapped(int index) {
//     if (isLoggedIn || index == 0) {
//       // Allow access to the login view only if not logged in
//       setState(() {
//         _selectedIndex = index;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Logga in för att komma åt detta informationsflöde"),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ParkeringsApp"),
//       ),
//       body: _views[_selectedIndex], // Display the current view
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           if (!isLoggedIn)
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.login),
//               label: 'Inloggning',
//             )
//           else
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.exit_to_app),
//               label: 'Logga Ut',
//             ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.directions_car),
//             label: 'Fordon',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.local_parking),
//             label: 'Parkeringsplats',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Aktiva Parkeringar',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: const Color.fromARGB(255, 64, 63, 63),
//         onTap: (isLoggedIn && _selectedIndex == 0)
//             ? (_) => _showLogoutConfirmation()
//             : _onItemTapped,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:parkingapp_user/views/login_view.dart';
import 'package:parkingapp_user/views/vehicle_management_view.dart';
import 'package:parkingapp_user/views/parkingspace_selection_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Default selected index
  bool isLoggedIn = false; // Track login state

  // Define all views
  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();
    _views = [
      const VehicleManagementView(),
      const ParkingSpaceSelectionScreen(),
      //const ActiveParkingView(),
    ];
  }

  // Handle successful login
  void _onLoginSuccess() {
    setState(() {
      isLoggedIn = true;
      _selectedIndex = 0; // Navigate to the first main view
    });
  }

  // Handle logout
  Future<void> _logout() async {
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bekräfta utloggning"),
          content: const Text("Vill du logga ut?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Avbryt"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logga ut"),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      setState(() {
        isLoggedIn = false; // Return to the login view
      });
    }
  }

  // Handle navigation between tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoggedIn
          ? AppBar(
              title: const Text("ParkeringsApp"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
            )
          : null, // No AppBar for login view
      body: isLoggedIn
          ? _views[_selectedIndex] // Show main views
          : LoginView(onLoginSuccess: _onLoginSuccess), // Show login view
      bottomNavigationBar: isLoggedIn
          ? BottomNavigationBar(
              items: const [
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
            )
          : null, // No navigation bar for login view
    );
  }
}
