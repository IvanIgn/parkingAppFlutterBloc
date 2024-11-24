import 'package:flutter/material.dart';

class ParkingSelectionScreen extends StatelessWidget {
  const ParkingSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Välj en Parkeringsplats",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logik för att visa parkeringsplatser
            },
            child: const Text("Visa Parkeringsplatser"),
          ),
        ],
      ),
    );
  }
}
