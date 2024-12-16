import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // To access the global isDarkModeNotifier

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkModeNotifier.value = prefs.getBool('isDarkMode') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _loadDarkModePreference(); // Ensure the current preference is loaded

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inställningar'),
      ),
      body: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: isDarkModeNotifier,
          builder: (context, isDarkMode, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Välj tema',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SwitchListTile(
                  title: const Text('Mörkt läge'),
                  value: isDarkMode,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    isDarkModeNotifier.value = value; // Update the notifier
                    await prefs.setBool(
                        'isDarkMode', value); // Persist the preference
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tema ändrades till ${value ? 'Mörkt' : 'Ljust'} läge',
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
