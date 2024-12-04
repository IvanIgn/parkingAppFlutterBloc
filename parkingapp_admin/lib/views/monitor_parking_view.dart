import 'package:flutter/material.dart';

class MonitorParkingScreen extends StatelessWidget {
  const MonitorParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Övervakning av Aktiva Parkeringar",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logik för att visa aktiva parkeringar
            },
            child: const Text("Visa Aktiva Parkeringar"),
          ),
        ],
      ),
    );
  }
}
