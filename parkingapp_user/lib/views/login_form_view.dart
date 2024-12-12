// import 'package:flutter/material.dart';
// import 'package:cli/utils/validator.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginFormView extends StatefulWidget {
//   //const LoginFormView({super.key});

//   const LoginFormView({super.key, required this.onLoginSuccess});

//   final VoidCallback onLoginSuccess;

//   @override
//   _LoginFormViewState createState() => _LoginFormViewState();
// }

// class _LoginFormViewState extends State<LoginFormView> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController personNumController = TextEditingController();

//   String? personNameError;
//   String? personNumError;

//   final PersonRepository _personRepository = PersonRepository.instance;

//   void _login() async {
//     final personName = nameController.text;
//     final personNum = personNumController.text;

//     setState(() {
//       personNameError = personName.isEmpty || !Validator.isString(personName)
//           ? "Ogiltigt namn"
//           : null;
//       personNumError = personNum.isEmpty ? "Personnummer krävs" : null;
//     });

//     if (personNameError == null && personNumError == null) {
//       try {
//         final personList = await _personRepository.getAllPersons();
//         final personMap = {
//           for (var person in personList) person.personNumber: person
//         };

//         if (!personMap.containsKey(personNum) ||
//             personMap[personNum]?.name != personName) {
//           setState(() {
//             personNumError =
//                 'Personen "$personName" med personnummer "$personNum" finns inte.';
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(
//                     'Personen "$personName"  med personnummer "$personNum" finns inte.')),
//           );
//           return;
//         } else if (personMap[personNum]?.name == personName) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Inloggad framgångsrikt")),
//           );
//           widget.onLoginSuccess(); // Call the success callback
//           Navigator.pop(context); // Go back to the previous screen
//           final prefs = await SharedPreferences.getInstance();
//           prefs.setString('loggedInName', personName);
//           prefs.setString('loggedInPersonNum', personNum);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Ett fel uppstod: $e")),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Kontrollera uppgifterna och försök igen")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Logga In")),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 400),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                           labelText: "Namn",
//                           errorText: personNameError,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: personNumController,
//                         decoration: InputDecoration(
//                           labelText: "Personnummer",
//                           errorText: personNumError,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton(
//                         onPressed: _login,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 16),
//                           textStyle: const TextStyle(fontSize: 16),
//                         ),
//                         child: const Text("Logga In"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cli/utils/validator.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormView extends StatefulWidget {
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

  /// Perform login and update the shared preferences.
  void _login() async {
    final personName = nameController.text.trim();
    final personNum = personNumController.text.trim();

    setState(() {
      personNameError = personName.isEmpty || !Validator.isString(personName)
          ? "Ogiltigt namn"
          : null;
      personNumError = personNum.isEmpty ? "Personnummer krävs" : null;
    });

    if (personNameError == null && personNumError == null) {
      try {
        // Fetch user data from the repository
        final personList = await _personRepository.getAllPersons();
        final personMap = {
          for (var person in personList) person.personNumber: person
        };

        if (!personMap.containsKey(personNum) ||
            personMap[personNum]?.name != personName) {
          setState(() {
            personNumError =
                'Personen "$personName" med personnummer "$personNum" finns inte.';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Personen "$personName"  med personnummer "$personNum" finns inte.')),
          );
          return;
        }

        // Save login state and invoke success callback
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInName', personName);
        await prefs.setString('loggedInPersonNum', personNum);
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inloggad framgångsrikt")),
        );

        widget.onLoginSuccess(); // Notify parent widget of login success
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
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("Logga In"),

        // Redirect to the first main screen post-login\]
      ),
    );
  }
}




// // class LoginScreen extends StatelessWidget {
// //   final VoidCallback onLoginSuccess;

// //   const LoginScreen({super.key, required this.onLoginSuccess});

// //   @override
// //   Widget build(BuildContext context) {
// //     return LoginFormView(onLoginSuccess: onLoginSuccess);
// //   }
// // }