import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

class ManagePersonsView extends StatefulWidget {
  const ManagePersonsView({super.key});

  @override
  _ManagePersonsViewState createState() => _ManagePersonsViewState();
}

class _ManagePersonsViewState extends State<ManagePersonsView> {
  late Future<List<Person>> _personsFuture;

  @override
  void initState() {
    super.initState();
    _refreshPersons();
  }

  void _refreshPersons() {
    setState(() {
      _personsFuture = PersonRepository.instance.getAllPersons();
    });
  }

  Future<bool> _personNumberExists(String personNumber) async {
    final persons = await PersonRepository.instance.getAllPersons();
    return persons.any((person) => person.personNumber == personNumber);
  }

  void _showAddPersonDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController personNumberController =
        TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lägg till person"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Namn',
                  ),
                ),
                TextField(
                  controller: personNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Personnummer',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Avbryt"),
            ),
            ElevatedButton(
              onPressed: () async {
                final personNumber = personNumberController.text;
                final name = nameController.text;

                if (await _personNumberExists(personNumber)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Personen $name med detta personnummer $personNumber finns redan"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                final newPerson = Person(
                  name: name,
                  personNumber: personNumber,
                );

                await PersonRepository.instance.createPerson(newPerson);
                Navigator.of(context).pop();
                _refreshPersons();
              },
              child: const Text("Spara"),
            ),
          ],
        );
      },
    );
  }

  void _showEditPersonDialog(BuildContext context, Person person) {
    final TextEditingController nameController =
        TextEditingController(text: person.name);
    final TextEditingController personNumberController =
        TextEditingController(text: person.personNumber);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uppdatera person"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Namn',
                  ),
                ),
                TextField(
                  controller: personNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Personnummer',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Avbryt"),
            ),
            ElevatedButton(
              onPressed: () async {
                final personNumber = personNumberController.text;
                final name = nameController.text;

                if (personNumber != person.personNumber &&
                    await _personNumberExists(personNumber)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Personen $name med detta personnummer $personNumber finns redan"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  return;
                }

                final updatedPerson = Person(
                  id: person.id,
                  name: name,
                  personNumber: personNumber,
                );

                await PersonRepository.instance
                    .updatePerson(person.id, updatedPerson);
                Navigator.of(context).pop();
                _refreshPersons();
              },
              child: const Text("Spara"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Person person) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bekräfta borttagning"),
          content: Text(
            "Är du säker på att du vill ta bort personen med ID ${person.id}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Avbryt"),
            ),
            ElevatedButton(
              onPressed: () async {
                await PersonRepository.instance.deletePerson(person.id);
                Navigator.of(context).pop();
                _refreshPersons();
              },
              child: const Text("Ta bort"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hantera personer"),
      ),
      body: FutureBuilder<List<Person>>(
        future: _personsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Fel vid hämtning av data: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Inga personer tillgängliga.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final personsList = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: personsList.length,
            itemBuilder: (context, index) {
              final person = personsList[index];
              return ListTile(
                title: Text(
                  'Person ID: ${person.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namn: ${person.name}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Personnummer: ${person.personNumber}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showEditPersonDialog(context, person);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, person);
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                color: Colors.black87,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPersonDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
