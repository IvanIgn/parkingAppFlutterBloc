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
            ElevatedButton(
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
            const SizedBox(height: 10), // Added spacing between the buttons
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
