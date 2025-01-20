import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:parkingapp_admin/blocs/vehicle/vehicle_bloc.dart';

// THIS CLASS WORKS

class ManageVehiclesView extends StatelessWidget {
  const ManageVehiclesView({super.key});

  void _showAddVehicleDialog(BuildContext context) {
    final TextEditingController regNumberController = TextEditingController();
    String selectedVehicleType = 'Bil';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    DropdownButtonFormField<String>(
                      value: selectedVehicleType,
                      items: <String>[
                        'Bil',
                        'Lastbil',
                        'Motorcykel',
                        'Moped',
                        'Annat'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedVehicleType = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Fordonstyp',
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
                  onPressed: () {
                    final regNumber = regNumberController.text;

                    if (!_isValidRegNumber(regNumber)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Fordons registreringsnumret ska följa detta format: ABC123"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }

                    final newVehicle = Vehicle(
                      regNumber: regNumber,
                      vehicleType: selectedVehicleType,
                    );

                    context.read<VehicleBloc>().add(AddVehicle(newVehicle));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Spara"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditVehicleDialog(BuildContext context, Vehicle vehicle) {
    final TextEditingController regNumberController =
        TextEditingController(text: vehicle.regNumber);
    String selectedVehicleType = vehicle.vehicleType;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Uppdatera fordon"),
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
                    DropdownButtonFormField<String>(
                      value: selectedVehicleType,
                      items: <String>[
                        'Bil',
                        'Motorcykel',
                        'Lastbil',
                        'Moped',
                        'Annat'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedVehicleType = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Fordonstyp',
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
                  onPressed: () {
                    final regNumber = regNumberController.text;

                    if (!_isValidRegNumber(regNumber)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Fordons registreringsnumret ska följa detta format: ABC123"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    final updatedVehicle = Vehicle(
                      id: vehicle.id,
                      regNumber: regNumber,
                      vehicleType: selectedVehicleType,
                    );

                    context
                        .read<VehicleBloc>()
                        .add(UpdateVehicle(updatedVehicle));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Spara"),
                ),
              ],
            );
          },
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
              onPressed: () {
                context.read<VehicleBloc>().add(DeleteVehicle(vehicle.id));
                Navigator.of(context).pop();
              },
              child: const Text("Ta bort"),
            ),
          ],
        );
      },
    );
  }

  bool _isValidRegNumber(String regNumber) {
    final regExp = RegExp(r'^[A-Z]{3}[0-9]{3}$');
    return regExp.hasMatch(regNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hantera fordon"),
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleError) {
            return Center(
              child: Text(
                'Fel vid hämtning av data: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (state is VehicleLoaded) {
            final vehiclesList = state.vehicles;

            if (vehiclesList.isEmpty) {
              return const Center(
                child: Text(
                  'Inga fordon tillgängliga.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: vehiclesList.length,
              itemBuilder: (context, index) {
                final vehicle = vehiclesList[index];
                return ListTile(
                  title: Text(
                    'Fordon ID: ${vehicle.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
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
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditVehicleDialog(context, vehicle);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, vehicle);
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
          } else {
            return const SizedBox.shrink();
          }
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
}
