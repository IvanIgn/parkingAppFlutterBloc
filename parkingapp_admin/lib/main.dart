// // import 'package:flutter/material.dart';
// // import 'views/home_view.dart';

// // void main() {
// //   runApp(const ParkingAdminApp());
// // }

// // class ParkingAdminApp extends StatelessWidget {
// //   const ParkingAdminApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Parking Admin App',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: const HomeScreen(),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../views/home_view.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Load the saved theme mode from SharedPreferences
//   final prefs = await SharedPreferences.getInstance();
//   final isDarkMode = prefs.getBool('isDarkMode') ?? false;

//   // Pass the ValueNotifier to MyApp
//   runApp(MyApp(isDarkMode: isDarkMode));
// }

// class MyApp extends StatelessWidget {
//   final bool isDarkMode;

//   const MyApp({super.key, required this.isDarkMode});

//   @override
//   Widget build(BuildContext context) {
//     // Create the ValueNotifier based on the saved theme mode
//     final ValueNotifier<bool> isDarkModeNotifier =
//         ValueNotifier<bool>(isDarkMode);

//     return ValueListenableBuilder<bool>(
//       valueListenable: isDarkModeNotifier,
//       builder: (context, isDarkMode, _) {
//         return MaterialApp(
//           theme: ThemeData.light(), // Light theme
//           darkTheme: ThemeData.dark(), // Dark theme
//           themeMode: isDarkMode
//               ? ThemeMode.dark
//               : ThemeMode.light, // Set the theme mode
//           home: HomeScreen(
//               isDarkModeNotifier:
//                   isDarkModeNotifier), // Pass the ValueNotifier to HomeScreen
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/home_view.dart';

// Global ValueNotifier for dark mode
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  isDarkModeNotifier.value = prefs.getBool('isDarkMode') ?? false;

  runApp(const ParkingAdminApp());
}

class ParkingAdminApp extends StatelessWidget {
  const ParkingAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Parking Admin App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
