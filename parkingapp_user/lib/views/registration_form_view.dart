import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/registration/registration_bloc.dart';

class RegistrationView extends StatelessWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final personNumController = TextEditingController();
    final confirmPersonNumController = TextEditingController();

    String? nameError;
    String? personNumError;

    return Scaffold(
      appBar: AppBar(title: const Text("Registrera Dig")),
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
                  child: BlocConsumer<RegistrationBloc, RegistrationState>(
                    listener: (context, state) {
                      if (state is RegistrationSuccess) {
                        // Show success message in SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.successMessage)),
                        );
                        Navigator.of(context).pop(); // Navigate back
                      } else if (state is RegistrationError) {
                        // Show error message in SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is RegistrationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Namn",
                              errorText: nameError,
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
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: confirmPersonNumController,
                            decoration: InputDecoration(
                              labelText: "Bekräfta personnummer",
                              errorText: personNumError,
                              border: const OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // Dispatch registration event
                              context.read<RegistrationBloc>().add(
                                    RegistrationSubmitted(
                                      name: nameController.text,
                                      personNum: personNumController.text,
                                      confirmPersonNum:
                                          confirmPersonNumController.text,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text("Registrera"),
                          ),
                        ],
                      );
                    },
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
