// import 'package:flutter/material.dart';
// import 'package:shared/shared.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:intl/intl.dart';

// class MonitorParkingsView extends StatefulWidget {
//   const MonitorParkingsView({super.key});

//   @override
//   MonitorParkingSViewState createState() => MonitorParkingSViewState();
// }

// class MonitorParkingSViewState extends State<MonitorParkingsView> {
//   late Future<List<Parking>> _parkingsFuture;
//   late Future<List<Vehicle>> _vehiclesFuture;
//   late Future<List<ParkingSpace>> _parkingSpacesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _refreshParkings();
//     _vehiclesFuture = VehicleRepository.instance.getAllVehicles();
//     _parkingSpacesFuture =
//         ParkingSpaceRepository.instance.getAllParkingSpaces();
//   }

//   void _refreshParkings() {
//     setState(() {
//       _parkingsFuture = ParkingRepository.instance.getAllParkings();
//     });
//   }

//   /// Displays a dialog to add a new parking record.
//   void _showAddParkingDialog(BuildContext context) {
//     final TextEditingController startTimeController = TextEditingController();
//     final TextEditingController endTimeController = TextEditingController();
//     Vehicle? selectedVehicle;
//     ParkingSpace? selectedParkingSpace;

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Lägg till parkering"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: startTimeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Starttid (yyyy-MM-dd HH:mm)',
//                   ),
//                 ),
//                 TextField(
//                   controller: endTimeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Sluttid (yyyy-MM-dd HH:mm)',
//                   ),
//                 ),
//                 FutureBuilder<List<Vehicle>>(
//                   future: _vehiclesFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text(
//                           'Fel vid hämtning av fordon: ${snapshot.error}');
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Text('Inga fordon tillgängliga.');
//                     }

//                     final vehicles = snapshot.data!;
//                     return DropdownButtonFormField<Vehicle>(
//                       decoration:
//                           const InputDecoration(labelText: 'Välj fordon'),
//                       items: vehicles.map((vehicle) {
//                         return DropdownMenuItem<Vehicle>(
//                           value: vehicle,
//                           child: Text(vehicle.regNumber),
//                         );
//                       }).toList(),
//                       onChanged: (vehicle) {
//                         setState(() {
//                           selectedVehicle = vehicle;
//                         });
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 FutureBuilder<List<ParkingSpace>>(
//                   future: _parkingSpacesFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text(
//                           'Fel vid hämtning av parkeringsplatser: ${snapshot.error}');
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Text('Inga parkeringsplatser tillgängliga.');
//                     }

//                     final parkingSpaces = snapshot.data!;
//                     return DropdownButtonFormField<ParkingSpace>(
//                       decoration: const InputDecoration(
//                           labelText: 'Välj parkeringsplats'),
//                       items: parkingSpaces.map((parkingSpace) {
//                         return DropdownMenuItem<ParkingSpace>(
//                           value: parkingSpace,
//                           child: Text(parkingSpace.address),
//                         );
//                       }).toList(),
//                       onChanged: (parkingSpace) {
//                         setState(() {
//                           selectedParkingSpace = parkingSpace;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Avbryt"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (selectedVehicle == null || selectedParkingSpace == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Välj ett fordon och en parkeringsplats"),
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                   return;
//                 }

//                 final newParking = Parking(
//                   id: 0, // Assign ID in the repository
//                   startTime: DateTime.parse(startTimeController.text),
//                   endTime: DateTime.parse(endTimeController.text),
//                   vehicle: selectedVehicle!,
//                   parkingSpace: selectedParkingSpace!,
//                 );

//                 await ParkingRepository.instance.createParking(newParking);

//                 Navigator.of(context).pop();
//                 _refreshParkings();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Displays a dialog to edit an existing parking record.
//   void _showEditParkingDialog(BuildContext context, Parking parking) {
//     final TextEditingController startTimeController = TextEditingController(
//         text: DateFormat('yyyy-MM-dd HH:mm').format(parking.startTime));
//     final TextEditingController endTimeController = TextEditingController(
//         text: DateFormat('yyyy-MM-dd HH:mm').format(parking.endTime));
//     final TextEditingController vehicleRegController =
//         TextEditingController(text: parking.vehicle?.regNumber ?? '');
//     final TextEditingController parkingSpaceAddressController =
//         TextEditingController(text: parking.parkingSpace?.address ?? '');

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Redigera parkering"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: startTimeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Starttid (yyyy-MM-dd HH:mm)',
//                   ),
//                 ),
//                 TextField(
//                   controller: endTimeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Sluttid (yyyy-MM-dd HH:mm)',
//                   ),
//                 ),
//                 TextField(
//                   controller: vehicleRegController,
//                   decoration: const InputDecoration(
//                     labelText: 'Fordonets registreringsnummer',
//                   ),
//                 ),
//                 TextField(
//                   controller: parkingSpaceAddressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Parkeringsplats adress',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Avbryt"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final updatedParking = Parking(
//                   id: parking.id,
//                   startTime: DateTime.parse(startTimeController.text),
//                   endTime: DateTime.parse(endTimeController.text),
//                   vehicle: Vehicle(
//                     regNumber: vehicleRegController.text,
//                     vehicleType:
//                         'defaultType', // Replace 'defaultType' with the appropriate value
//                   ),
//                   parkingSpace: ParkingSpace(
//                     address: parkingSpaceAddressController.text,
//                     pricePerHour: 0, // Replace 0 with the appropriate value
//                   ),
//                 );

//                 await ParkingRepository.instance
//                     .updateParking(parking.id, updatedParking);

//                 Navigator.of(context).pop();
//                 _refreshParkings();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Aktiva Parkeringar"),
//       ),
//       body: FutureBuilder<List<Parking>>(
//         future: _parkingsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Fel vid hämtning av data: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text(
//                 'Inga aktiva parkeringar tillgängliga.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           final parkingsList = snapshot.data!;
//           return ListView.separated(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: parkingsList.length,
//             itemBuilder: (context, index) {
//               final parking = parkingsList[index];
//               return ListTile(
//                 title: Text(
//                   'Parkerings-ID: ${parking.id}',
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Starttid: ${parking.startTime}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     Text(
//                       'Sluttid: ${parking.endTime}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     if (parking.vehicle != null)
//                       Text(
//                         'Registreringsnummer: ${parking.vehicle!.regNumber}',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     if (parking.parkingSpace != null)
//                       Text(
//                         'Plats: ${parking.parkingSpace!.address ?? 'Okänd'}',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                   ],
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => _showEditParkingDialog(context, parking),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         _showDeleteConfirmationDialog(context, parking);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) {
//               return const Divider(
//                 thickness: 1,
//                 color: Colors.black87,
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddParkingDialog(context),
//         tooltip: 'Lägg till parkering',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showDeleteConfirmationDialog(BuildContext context, Parking parking) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Bekräfta borttagning"),
//           content: Text(
//             "Är du säker på att du vill ta bort parkeringen med ID ${parking.id}?",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Avbryt"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await ParkingRepository.instance.deleteParking(parking.id);

//                 Navigator.of(context).pop();
//                 _refreshParkings();
//               },
//               child: const Text("Ta bort"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// monitor_parkings_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/parking/parking_bloc.dart';
import 'package:shared/shared.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:intl/intl.dart';

class MonitorParkingsView extends StatelessWidget {
  const MonitorParkingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParkingsBloc()..add(FetchParkingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Aktiva Parkeringar"),
        ),
        body: BlocBuilder<ParkingsBloc, ParkingsState>(
          builder: (context, state) {
            if (state is ParkingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ParkingsError) {
              return Center(
                child: Text(
                  'Fel vid hämtning av data: ${state.message}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is ParkingsLoaded) {
              final parkingsList = state.parkings;
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: parkingsList.length,
                itemBuilder: (context, index) {
                  final parking = parkingsList[index];
                  return ListTile(
                    title: Text(
                      'Parkerings-ID: ${parking.id}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starttid: ${parking.startTime}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Sluttid: ${parking.endTime}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (parking.vehicle != null)
                          Text(
                            'Registreringsnummer: ${parking.vehicle!.regNumber}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        if (parking.parkingSpace != null)
                          Text(
                            'Plats: ${parking.parkingSpace!.address ?? 'Okänd'}',
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
                            _showEditParkingDialog(context, parking);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, parking);
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
            }
            return const Center(
                child: Text('Inga aktiva parkeringar tillgängliga.'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddParkingDialog(context),
          tooltip: 'Lägg till parkering',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddParkingDialog(BuildContext context) {
    // Same as the original function, but now you can dispatch the AddParkingEvent using:
    // context.read<MonitorParkingsBloc>().add(AddParkingEvent(newParking));
  }

  void _showEditParkingDialog(BuildContext context, Parking parking) {
    // Same as the original function, but now you can dispatch the EditParkingEvent using:
    // context.read<MonitorParkingsBloc>().add(EditParkingEvent(updatedParking));
  }

  void _showDeleteConfirmationDialog(BuildContext context, Parking parking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bekräfta borttagning"),
          content: Text(
            "Är du säker på att du vill ta bort parkeringen med ID ${parking.id}?",
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
                context
                    .read<ParkingsBloc>()
                    .add(DeleteParkingEvent(parking.id));
                Navigator.of(context).pop();
              },
              child: const Text("Ta bort"),
            ),
          ],
        );
      },
    );
  }
}
