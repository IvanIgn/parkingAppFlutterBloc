import 'package:flutter/material.dart';

class ActiveParkingScreen extends StatelessWidget {
  const ActiveParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Aktiva Parkeringar",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
