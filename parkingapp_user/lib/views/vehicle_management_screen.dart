import 'package:flutter/material.dart';

class VehicleManagementScreen extends StatelessWidget {
  const VehicleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Hantera Ditt Fordon",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logik för att lägga till ett fordon
            },
            child: const Text("Lägg Till Fordon"),
          ),
          ElevatedButton(
            onPressed: () {
              // Logik för att visa användarens fordon
            },
            child: const Text("Visa Fordon"),
          ),
        ],
      ),
    );
  }
}
