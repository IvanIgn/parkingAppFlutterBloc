import 'package:flutter/material.dart';

class ManageParkingScreen extends StatelessWidget {
  const ManageParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Hantera Parkeringsplatser",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logik för att lägga till eller redigera parkeringsplatser
            },
            child: const Text("Lägg till/redigera Parkeringsplatser"),
          ),
          ElevatedButton(
            onPressed: () {
              // Logik för att ta bort parkeringsplatser
            },
            child: const Text("Ta bort Parkeringsplatser"),
          ),
        ],
      ),
    );
  }
}
