// import 'package:flutter/material.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:shared/shared.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VehicleManagementView extends StatefulWidget {
//   const VehicleManagementView({super.key});

//   @override
//   _VehicleManagementViewState createState() => _VehicleManagementViewState();
// }

// class _VehicleManagementViewState extends State<VehicleManagementView> {
//   late Future<List<Vehicle>> _vehiclesFuture;
//   String? loggedInName;
//   String? loggedInPersonNum;

//   @override
//   void initState() {
//     super.initState();
//     _loadLoggedInUser();
//     _refreshVehicles();
//   }

//   Future<void> _loadLoggedInUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       loggedInName = prefs.getString('loggedInName');
//       loggedInPersonNum = prefs.getString('loggedInPersonNum');
//     });
//   }

//   void _refreshVehicles() {
//     setState(() {
//       _vehiclesFuture = VehicleRepository.instance.getAllVehicles();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Hantera dina fordon"),
//       ),
//       body: Column(
//         children: [
//           if (loggedInName != null && loggedInPersonNum != null)
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Inloggad som: $loggedInName (Personnummer: $loggedInPersonNum)',
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ),
//           Expanded(
//             child: FutureBuilder<List<Vehicle>>(
//               future: _vehiclesFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       'Fel vid hämtning av data: ${snapshot.error}',
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'Inga fordon tillgängliga.',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   );
//                 }

//                 // Filtrera fordon baserat på inloggad användare
//                 final vehiclesList = snapshot.data!
//                     .where((vehicle) =>
//                         vehicle.owner?.personNumber == loggedInPersonNum)
//                     .toList();

//                 if (vehiclesList.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'Inga fordon tillhör denna användare.',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   );
//                 }

//                 return ListView.separated(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: vehiclesList.length,
//                   itemBuilder: (context, index) {
//                     final vehicle = vehiclesList[index];
//                     return ListTile(
//                       title: Text(
//                         'Fordon ID: ${vehicle.id}',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Registreringsnummer: ${vehicle.regNumber}',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           Text(
//                             'Fordonstyp: ${vehicle.vehicleType}',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           if (vehicle.owner != null)
//                             Text(
//                               'Ägare: ${vehicle.owner!.name}',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               _showUpdateVehicleDialog(context, vehicle);
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               _showDeleteConfirmationDialog(context, vehicle);
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   separatorBuilder: (context, index) {
//                     return const Divider(
//                       thickness: 1,
//                       color: Colors.black,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddVehicleDialog(context);
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddVehicleDialog(BuildContext context) {
//     final TextEditingController regNumberController = TextEditingController();
//     final TextEditingController vehicleTypeController = TextEditingController();

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Skapa nytt fordon"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: regNumberController,
//                   decoration: const InputDecoration(
//                     labelText: 'Registreringsnummer',
//                   ),
//                 ),
//                 TextField(
//                   controller: vehicleTypeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Fordonstyp',
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
//                 Vehicle newVehicle = Vehicle(
//                   regNumber: regNumberController.text,
//                   vehicleType: vehicleTypeController.text,
//                   owner: loggedInName != null
//                       ? Person(
//                           name: loggedInName!,
//                           personNumber: loggedInPersonNum ?? 'N/A',
//                         )
//                       : null,
//                 );

//                 await VehicleRepository.instance.createVehicle(newVehicle);

//                 Navigator.of(context).pop();
//                 _refreshVehicles();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteConfirmationDialog(BuildContext context, Vehicle vehicle) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Bekräfta borttagning"),
//           content: Text(
//             "Är du säker på att du vill ta bort fordonet med ID ${vehicle.id}?",
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
//                 await VehicleRepository.instance.deleteVehicle(vehicle.id);

//                 Navigator.of(context).pop();
//                 _refreshVehicles();
//               },
//               child: const Text("Ta bort"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showUpdateVehicleDialog(BuildContext context, Vehicle vehicle) {
//     final TextEditingController regNumberController =
//         TextEditingController(text: vehicle.regNumber);
//     final TextEditingController vehicleTypeController =
//         TextEditingController(text: vehicle.vehicleType);

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Uppdatera fordon"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: regNumberController,
//                   decoration: const InputDecoration(
//                     labelText: 'Registreringsnummer',
//                   ),
//                 ),
//                 TextField(
//                   controller: vehicleTypeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Fordonstyp',
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
//                 Vehicle updatedVehicle = Vehicle(
//                   id: vehicle.id,
//                   regNumber: regNumberController.text,
//                   vehicleType: vehicleTypeController.text,
//                   owner: vehicle.owner,
//                 );

//                 await VehicleRepository.instance
//                     .updateVehicle(vehicle.id, updatedVehicle);

//                 Navigator.of(context).pop();
//                 _refreshVehicles();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:shared/shared.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VehicleManagementView extends StatefulWidget {
//   const VehicleManagementView({super.key});

//   @override
//   _VehicleManagementViewState createState() => _VehicleManagementViewState();
// }

// class _VehicleManagementViewState extends State<VehicleManagementView> {
//   late Future<List<Vehicle>> _vehiclesFuture;
//   String? loggedInName;
//   String? loggedInPersonNum;
//   Vehicle? _selectedVehicle; // Tracks the selected vehicle

//   @override
//   void initState() {
//     super.initState();
//     _loadLoggedInUser();
//     _refreshVehicles();
//   }

//   Future<void> _loadLoggedInUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       loggedInName = prefs.getString('loggedInName');
//       loggedInPersonNum = prefs.getString('loggedInPersonNum');
//     });
//   }

//   void _refreshVehicles() {
//     setState(() {
//       _vehiclesFuture = VehicleRepository.instance.getAllVehicles();
//     });
//   }

//   void _selectVehicle(Vehicle vehicle) {
//     setState(() {
//       _selectedVehicle = vehicle;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Hantera dina fordon"),
//       ),
//       body: Column(
//         children: [
//           if (loggedInName != null && loggedInPersonNum != null)
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Inloggad som: $loggedInName (Personnummer: $loggedInPersonNum)',
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ),
//           if (_selectedVehicle != null)
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               color: Colors.green.withOpacity(0.2),
//               child: Text(
//                 'Valt Fordon:\n'
//                 'ID: ${_selectedVehicle!.id}\n'
//                 'Registreringsnummer: ${_selectedVehicle!.regNumber}\n'
//                 'Typ: ${_selectedVehicle!.vehicleType}',
//                 textAlign: TextAlign.center,
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           Expanded(
//             child: FutureBuilder<List<Vehicle>>(
//               future: _vehiclesFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       'Fel vid hämtning av data: ${snapshot.error}',
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'Inga fordon tillgängliga.',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   );
//                 }

//                 final vehiclesList = snapshot.data!
//                     .where((vehicle) =>
//                         vehicle.owner?.personNumber == loggedInPersonNum)
//                     .toList();

//                 if (vehiclesList.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'Inga fordon tillhör denna användare.',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   );
//                 }

//                 return ListView.separated(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: vehiclesList.length,
//                   itemBuilder: (context, index) {
//                     final vehicle = vehiclesList[index];
//                     final isSelected =
//                         _selectedVehicle?.id == vehicle.id; // Check selection
//                     return ListTile(
//                       title: Text(
//                         'Fordon ID: ${vehicle.id}',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Registreringsnummer: ${vehicle.regNumber}',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           Text(
//                             'Fordonstyp: ${vehicle.vehicleType}',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           if (vehicle.owner != null)
//                             Text(
//                               'Ägare: ${vehicle.owner!.name}',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               _selectVehicle(vehicle);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   isSelected ? Colors.green : Colors.blue,
//                             ),
//                             child: Text(isSelected ? "Valt" : "Välj"),
//                           ),
//                           const SizedBox(width: 10),
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               _showUpdateVehicleDialog(context, vehicle);
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               _showDeleteConfirmationDialog(context, vehicle);
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   separatorBuilder: (context, index) {
//                     return const Divider(
//                       thickness: 1,
//                       color: Colors.black,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddVehicleDialog(context);
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   // Add, update, and delete dialog methods remain unchanged

//   void _showDeleteConfirmationDialog(BuildContext context, Vehicle vehicle) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Bekräfta borttagning"),
//           content: Text(
//             "Är du säker på att du vill ta bort fordonet med ID ${vehicle.id}?",
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
//                 await VehicleRepository.instance.deleteVehicle(vehicle.id);

//                 Navigator.of(context).pop();
//                 _refreshVehicles();
//               },
//               child: const Text("Ta bort"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showUpdateVehicleDialog(BuildContext context, Vehicle vehicle) {
//     final TextEditingController regNumberController =
//         TextEditingController(text: vehicle.regNumber);
//     final TextEditingController vehicleTypeController =
//         TextEditingController(text: vehicle.vehicleType);

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Uppdatera fordon"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: regNumberController,
//                   decoration: const InputDecoration(
//                     labelText: 'Registreringsnummer',
//                   ),
//                 ),
//                 TextField(
//                   controller: vehicleTypeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Fordonstyp',
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
//                 Vehicle updatedVehicle = Vehicle(
//                   id: vehicle.id,
//                   regNumber: regNumberController.text,
//                   vehicleType: vehicleTypeController.text,
//                   owner: vehicle.owner,
//                 );

//                 await VehicleRepository.instance
//                     .updateVehicle(vehicle.id, updatedVehicle);

//                 Navigator.of(context).pop();
//                 _refreshVehicles();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAddVehicleDialog(BuildContext context) {
//     final TextEditingController regNumberController = TextEditingController();
//     final TextEditingController vehicleTypeController = TextEditingController();

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Skapa nytt fordon"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: regNumberController,
//                   decoration: const InputDecoration(
//                     labelText: 'Registreringsnummer',
//                   ),
//                 ),
//                 TextField(
//                   controller: vehicleTypeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Fordonstyp',
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
//                 Vehicle newVehicle = Vehicle(
//                   regNumber: regNumberController.text,
//                   vehicleType: vehicleTypeController.text,
//                   owner: loggedInName != null
//                       ? Person(
//                           name: loggedInName!,
//                           personNumber: loggedInPersonNum ?? 'N/A',
//                         )
//                       : null,
//                 );

//                 await VehicleRepository.instance.createVehicle(newVehicle);

//                 Navigator.of(context).pop();
//                 _refreshVehicles();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleManagementView extends StatefulWidget {
  const VehicleManagementView({super.key});

  @override
  _VehicleManagementViewState createState() => _VehicleManagementViewState();
}

class _VehicleManagementViewState extends State<VehicleManagementView> {
  late Future<List<Vehicle>> _vehiclesFuture;
  String? loggedInName;
  String? loggedInPersonNum;
  Vehicle? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser();
    _loadSelectedVehicle(); // Load saved vehicle on initialization
    _refreshVehicles();
  }

  Future<void> _loadLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInName = prefs.getString('loggedInName');
      loggedInPersonNum = prefs.getString('loggedInPersonNum');
    });
  }

  Future<void> _loadSelectedVehicle() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedVehicleJson = prefs.getString('selectedVehicle');

    if (selectedVehicleJson != null) {
      final Map<String, dynamic> vehicleData = json.decode(selectedVehicleJson);
      setState(() {
        _selectedVehicle = Vehicle.fromJson(vehicleData);
      });
    }
  }

  Future<void> _saveSelectedVehicle(Vehicle vehicle) async {
    final prefs = await SharedPreferences.getInstance();
    final vehicleJson = json.encode(vehicle.toJson());

    await prefs.setString('selectedVehicle', vehicleJson);
    setState(() {
      _selectedVehicle = vehicle;
    });
  }

  void _refreshVehicles() {
    setState(() {
      _vehiclesFuture = VehicleRepository.instance.getAllVehicles();
    });
  }

  void _selectVehicle(Vehicle vehicle) {
    _saveSelectedVehicle(vehicle); // Save selected vehicle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hantera dina fordon"),
      ),
      body: Column(
        children: [
          if (loggedInName != null && loggedInPersonNum != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Inloggad som: $loggedInName (Personnummer: $loggedInPersonNum)',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          if (_selectedVehicle != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.green.withOpacity(0.2),
              child: Text(
                'Valt Fordon:\n'
                'ID: ${_selectedVehicle!.id}\n'
                'Registreringsnummer: ${_selectedVehicle!.regNumber}\n'
                'Typ: ${_selectedVehicle!.vehicleType}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Vehicle>>(
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

                final vehiclesList = snapshot.data!
                    .where((vehicle) =>
                        vehicle.owner?.personNumber == loggedInPersonNum)
                    .toList();

                if (vehiclesList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Inga fordon tillhör denna användare.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: vehiclesList.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehiclesList[index];
                    final isSelected =
                        _selectedVehicle?.id == vehicle.id; // Check selection
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _selectVehicle(vehicle);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.green : Colors.blue,
                            ),
                            child: Text(isSelected ? "Valt" : "Välj"),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showUpdateVehicleDialog(context, vehicle);
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
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddVehicleDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Add, update, and delete dialog methods remain unchanged

  void _showAddVehicleDialog(BuildContext context) {
    final TextEditingController regNumberController = TextEditingController();
    final TextEditingController vehicleTypeController = TextEditingController();

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
                  owner: loggedInName != null
                      ? Person(
                          name: loggedInName!,
                          personNumber: loggedInPersonNum ?? 'N/A',
                        )
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

  void _showUpdateVehicleDialog(BuildContext context, Vehicle vehicle) {
    final TextEditingController regNumberController =
        TextEditingController(text: vehicle.regNumber);
    final TextEditingController vehicleTypeController =
        TextEditingController(text: vehicle.vehicleType);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                TextField(
                  controller: vehicleTypeController,
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
              onPressed: () async {
                Vehicle updatedVehicle = Vehicle(
                  id: vehicle.id,
                  regNumber: regNumberController.text,
                  vehicleType: vehicleTypeController.text,
                  owner: vehicle.owner,
                );

                await VehicleRepository.instance
                    .updateVehicle(vehicle.id, updatedVehicle);

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
}
