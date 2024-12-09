import 'package:flutter/material.dart';
import 'package:parkingapp_user/views/login_form_view.dart';
import 'package:parkingapp_user/views/registration_form_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Välkommen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Logga in eller registrera dig",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Using SizedBox for uniform width
            SizedBox(
              width: 200, // Specify the desired button width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginFormView(onLoginSuccess: onLoginSuccess),
                    ),
                  );
                },
                child: const Text("Logga In"),
              ),
            ),
            const SizedBox(height: 10), // Added spacing between the buttons
            SizedBox(
              width: 200, // Same width for the second button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationView(),
                    ),
                  );
                },
                child: const Text("Registrera Dig"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
