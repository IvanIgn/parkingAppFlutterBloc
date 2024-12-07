import 'package:flutter/material.dart';
import 'package:cli/utils/validator.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

class LoginFormView extends StatefulWidget {
  //const LoginFormView({super.key});

  const LoginFormView({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  _LoginFormViewState createState() => _LoginFormViewState();
}

class _LoginFormViewState extends State<LoginFormView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController personNumController = TextEditingController();

  String? personNameError;
  String? personNumError;

  final PersonRepository _personRepository = PersonRepository.instance;

  void _login() async {
    final personName = nameController.text;
    final personNum = personNumController.text;

    setState(() {
      personNameError = personName.isEmpty || !Validator.isString(personName)
          ? "Ogiltigt namn"
          : null;
      personNumError = personNum.isEmpty ? "Personnummer krävs" : null;
    });

    if (personNameError == null && personNumError == null) {
      try {
        final personList = await _personRepository.getAllPersons();
        final personMap = {
          for (var person in personList) person.personNumber: person
        };

        if (!personMap.containsKey(personNum)) {
          final existingPersonName = personMap[personNum]?.name;
          setState(() {
            personNumError =
                'Personen med personnummer "$personNum" finns inte.';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Personen  med personnummer "$personNum" finns inte.')),
          );
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Inloggad framgångsrikt")),
          );
          // Navigate to the next screen or perform login action here
          //navigate to the next screen or perform login action here
          widget.onLoginSuccess();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ett fel uppstod: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Kontrollera uppgifterna och försök igen")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logga In")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Namn",
                          errorText: personNameError,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: personNumController,
                        decoration: InputDecoration(
                          labelText: "Personnummer",
                          errorText: personNumError,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text("Logga In"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  void _attemptLogin() {
    // Simulate login success
    onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _attemptLogin,
        child: const Text("Logga In"),
        // Redirect to the first main screen post-login\]
      ),
    );
  }
}
