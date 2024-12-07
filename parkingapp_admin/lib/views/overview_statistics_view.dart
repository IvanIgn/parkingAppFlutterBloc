import 'package:flutter/material.dart';

class OverviewStatisticsView extends StatelessWidget {
  const OverviewStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Översikt och Statistik",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logik för att visa statistik
            },
            child: const Text("Visa Statistik"),
          ),
          ElevatedButton(
            onPressed: () {
              // Logik för att exportera data
            },
            child: const Text("Exportera Data"),
          ),
        ],
      ),
    );
  }
}
