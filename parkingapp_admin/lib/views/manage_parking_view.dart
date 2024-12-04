import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

class ManageParkingScreen extends StatefulWidget {
  const ManageParkingScreen({super.key});

  @override
  _ManageParkingScreenState createState() => _ManageParkingScreenState();
}

class _ManageParkingScreenState extends State<ManageParkingScreen> {
  late Future<List<ParkingSpace>> _parkingSpacesFuture;

  @override
  void initState() {
    super.initState();
    _refreshParkingSpaces();
  }

  void _refreshParkingSpaces() {
    setState(() {
      _parkingSpacesFuture =
          ParkingSpaceRepository.instance.getAllParkingSpaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hantera Parkeringsplatser"),
      ),
      body: FutureBuilder<List<ParkingSpace>>(
        future: _parkingSpacesFuture,
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
                'Inga parkeringsplatser tillgängliga.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final parkingSpacesList = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: parkingSpacesList.length,
            itemBuilder: (context, index) {
              final parkingSpace = parkingSpacesList[index];
              return ListTile(
                title: Text(
                  'Parkeringsplats ID: ${parkingSpace.id}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address: ${parkingSpace.address ?? 'Okänd'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Pris per timme: ${parkingSpace.pricePerHour}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditParkingSpaceDialog(context, parkingSpace);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, parkingSpace);
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                color: Colors.grey,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddParkingSpaceDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditParkingSpaceDialog(
      BuildContext context, ParkingSpace parkingSpace) {
    final TextEditingController idController =
        TextEditingController(text: parkingSpace.id.toString());
    final TextEditingController addressController =
        TextEditingController(text: parkingSpace.address);
    final TextEditingController pricePerHourController =
        TextEditingController(text: parkingSpace.pricePerHour.toString());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uppdatera parkeringsplats"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Parkeringsplats ID',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Adress',
                  ),
                ),
                TextField(
                  controller: pricePerHourController,
                  decoration: const InputDecoration(
                    labelText: 'Pris per timme',
                  ),
                  keyboardType: TextInputType.number,
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
                ParkingSpace updatedParkingSpace = ParkingSpace(
                  id: int.parse(idController.text),
                  address: addressController.text,
                  pricePerHour: int.parse(pricePerHourController.text),
                );

                await ParkingSpaceRepository.instance.updateParkingSpace(
                    updatedParkingSpace.id, updatedParkingSpace);

                Navigator.of(context).pop();
                _refreshParkingSpaces();
              },
              child: const Text("Uppdatera"),
            ),
          ],
        );
      },
    );
  }

  void _showAddParkingSpaceDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController pricePerHourController =
        TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Skapa ny parkeringsplats"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Parkeringsplats ID',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Adress',
                  ),
                ),
                TextField(
                  controller: pricePerHourController,
                  decoration: const InputDecoration(
                    labelText: 'Pris per timme',
                  ),
                  keyboardType: TextInputType.number,
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
                ParkingSpace newParkingSpace = ParkingSpace(
                  id: int.parse(idController.text),
                  address: addressController.text,
                  pricePerHour: int.parse(pricePerHourController.text),
                );

                await ParkingSpaceRepository.instance
                    .createParkingSpace(newParkingSpace);

                Navigator.of(context).pop();
                _refreshParkingSpaces();
              },
              child: const Text("Spara"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ParkingSpace parkingSpace) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bekräfta borttagning"),
          content: Text(
            "Är du säker på att du vill ta bort parkeringsplatsen med ID ${parkingSpace.id}?",
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
                await ParkingSpaceRepository.instance
                    .deleteParkingSpace(parkingSpace.id);

                Navigator.of(context).pop();
                _refreshParkingSpaces();
              },
              child: const Text("Ta bort"),
            ),
          ],
        );
      },
    );
  }
}
