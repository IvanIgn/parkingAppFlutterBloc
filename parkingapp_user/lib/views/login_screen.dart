import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Logga in eller registrera dig",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logik för inloggning
            },
            child: const Text("Logga In"),
          ),
          ElevatedButton(
            onPressed: () {
              // Logik för registrering
            },
            child: const Text("Registrera Dig"),
          ),
        ],
      ),
    );
  }
}
