import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

class VehicleManagementView extends StatefulWidget {
  const VehicleManagementView({super.key});

  @override
  _VehicleManagementViewState createState() => _VehicleManagementViewState();
}

class _VehicleManagementViewState extends State<VehicleManagementView> {
  late Future<List<Vehicle>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _refreshVehicles();
  }

  void _refreshVehicles() {
    setState(() {
      _vehiclesFuture = VehicleRepository.instance.getAllVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hantera Fordon"),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: _vehiclesFuture,
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
                'Inga fordon tillgängliga.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final vehiclesList = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: vehiclesList.length,
            itemBuilder: (context, index) {
              final vehicle = vehiclesList[index];
              return ListTile(
                title: Text(
                  'Fordon ID: ${vehicle.id}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registreringsnummer: ${vehicle.regNumber}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Fordonstyp: ${vehicle.vehicleType}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (vehicle.owner != null)
                      Text(
                        'Ägare: ${vehicle.owner!.name}',
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, vehicle);
                  },
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
          _showAddVehicleDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    final TextEditingController regNumberController = TextEditingController();
    final TextEditingController vehicleTypeController = TextEditingController();
    final TextEditingController ownerNameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Skapa nytt fordon"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: regNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Registreringsnummer',
                  ),
                ),
                TextField(
                  controller: vehicleTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Fordonstyp',
                  ),
                ),
                TextField(
                  controller: ownerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Ägarens namn',
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
                Vehicle newVehicle = Vehicle(
                  regNumber: regNumberController.text,
                  vehicleType: vehicleTypeController.text,
                  owner: ownerNameController.text.isNotEmpty
                      ? Person(
                          name: ownerNameController.text,
                          personNumber:
                              '1234567890') // Replace '1234567890' with the actual person number  add person info frpm the login view
                      : null,
                );

                await VehicleRepository.instance.createVehicle(newVehicle);

                Navigator.of(context).pop();
                _refreshVehicles();
              },
              child: const Text("Spara"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bekräfta borttagning"),
          content: Text(
            "Är du säker på att du vill ta bort fordonet med ID ${vehicle.id}?",
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
                await VehicleRepository.instance.deleteVehicle(vehicle.id);

                Navigator.of(context).pop();
                _refreshVehicles();
              },
              child: const Text("Ta bort"),
            ),
          ],
        );
      },
    );
  }
}
