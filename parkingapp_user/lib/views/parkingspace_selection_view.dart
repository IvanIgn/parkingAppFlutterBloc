import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ParkingSpaceSelectionScreen extends StatefulWidget {
//   const ParkingSpaceSelectionScreen({super.key});

//   @override
//   _ParkingSpaceSelectionScreenState createState() =>
//       _ParkingSpaceSelectionScreenState();
// }

// class _ParkingSpaceSelectionScreenState
//     extends State<ParkingSpaceSelectionScreen> {
//   late Future<List<ParkingSpace>> _parkingSpacesFuture;

//   String? loggedInName;
//   String? loggedInPersonNum;

//   @override
//   void initState() {
//     super.initState();
//     _loadLoggedInUser();
//     _refreshParkingSpaces();
//   }

//   Future<void> _loadLoggedInUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       loggedInName = prefs.getString('loggedInName');
//       loggedInPersonNum = prefs.getString('loggedInPersonNum');
//     });
//   }

//   /// Loads all parking spaces from the repository.
//   void _refreshParkingSpaces() {
//     setState(() {
//       _parkingSpacesFuture =
//           ParkingSpaceRepository.instance.getAllParkingSpaces();
//     });
//   }

//   // /// Filters the parking spaces to show only available ones based on IDs.
//   // void _showAvailableParkingSpaces() {
//   //   setState(() {
//   //     _parkingSpacesFuture = _parkingSpacesFuture.then((parkingSpaces) {
//   //       return parkingSpaces
//   //           .where((space) => listAvailableParkingSpaces.contains(space.id))
//   //           .toList();
//   //     });
//   //   });
//   // }

//   /// Displays a dialog to add a new parking space.
//   void _showAddParkingSpaceDialog(BuildContext context) {
//     final TextEditingController idController = TextEditingController();
//     final TextEditingController addressController = TextEditingController();
//     final TextEditingController priceController = TextEditingController();

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Lägg till parkeringsplats"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: idController,
//                   decoration: const InputDecoration(
//                     labelText: 'Parkeringsplats ID',
//                   ),
//                 ),
//                 TextField(
//                   controller: addressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Adress',
//                   ),
//                 ),
//                 TextField(
//                   controller: priceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Pris per timme',
//                   ),
//                   keyboardType: TextInputType.number,
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
//                 final newParkingSpace = ParkingSpace(
//                   id: int.tryParse(idController.text) ?? 0,
//                   address: addressController.text,
//                   pricePerHour: int.tryParse(priceController.text) ?? 0,
//                 );

//                 await ParkingSpaceRepository.instance
//                     .createParkingSpace(newParkingSpace);

//                 Navigator.of(context).pop();
//                 _refreshParkingSpaces();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Displays a confirmation dialog to delete a parking space.
//   void _showDeleteConfirmationDialog(
//       BuildContext context, ParkingSpace parkingSpace) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Bekräfta borttagning"),
//           content: Text(
//             "Är du säker på att du vill ta bort parkeringsplatsen med ID ${parkingSpace.id}?",
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
//                 await ParkingRepository.instance.deleteParking(parkingSpace.id);

//                 Navigator.of(context).pop();
//                 _refreshParkingSpaces();
//               },
//               child: const Text("Ta bort"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Displays a dialog to edit a parking space.
//   void _showEditParkingSpaceDialog(
//       BuildContext context, ParkingSpace parkingSpace) {
//     final TextEditingController addressController =
//         TextEditingController(text: parkingSpace.address);
//     final TextEditingController priceController =
//         TextEditingController(text: parkingSpace.pricePerHour.toString());

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Redigera parkeringsplats"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: addressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Adress',
//                   ),
//                 ),
//                 TextField(
//                   controller: priceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Pris per timme',
//                   ),
//                   keyboardType: TextInputType.number,
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
//                 final updatedParkingSpace = ParkingSpace(
//                   id: parkingSpace.id,
//                   address: addressController.text,
//                   pricePerHour: int.tryParse(priceController.text) ??
//                       parkingSpace.pricePerHour,
//                 );

//                 await ParkingSpaceRepository.instance
//                     .updateParkingSpace(parkingSpace.id, updatedParkingSpace);

//                 Navigator.of(context).pop();
//                 _refreshParkingSpaces();
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
//         title: const Text("Parkeringsplatser"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: //_showAvailableParkingSpaces,
//                 _refreshParkingSpaces,
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<ParkingSpace>>(
//         future: _parkingSpacesFuture,
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
//                 'Inga parkeringsplatser tillgängliga.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           // // Filtrera fordon baserat på inloggad användare
//           //       final parkingSpacesList = snapshot.data!
//           //           .where((vehicle) =>
//           //               vehicle.owner?.personNumber == loggedInPersonNum)
//           //           .toList();

//           //       if (parkingSpacesList.isEmpty) {
//           //         return const Center(
//           //           child: Text(
//           //             'Inga parkeringsplatser tillhör denna användare.',
//           //             style: TextStyle(fontSize: 16),
//           //           ),
//           //         );
//           //       }

//           final parkingSpacesList = snapshot.data!;
//           return ListView.separated(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: parkingSpacesList.length,
//             itemBuilder: (context, index) {
//               final parkingSpace = parkingSpacesList[index];
//               return ListTile(
//                 title: Text(
//                   'Parkeringsplats ID: ${parkingSpace.id}',
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Adress: ${parkingSpace.address}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     Text(
//                       'Pris per timme: ${parkingSpace.pricePerHour} SEK',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () =>
//                           _showEditParkingSpaceDialog(context, parkingSpace),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () =>
//                           _showDeleteConfirmationDialog(context, parkingSpace),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) {
//               return const Divider(
//                 thickness: 1,
//                 color: Colors.grey,
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddParkingSpaceDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

class ParkingSpaceSelectionScreen extends StatefulWidget {
  const ParkingSpaceSelectionScreen({Key? key}) : super(key: key);

  @override
  _ParkingSpaceSelectionScreenState createState() =>
      _ParkingSpaceSelectionScreenState();
}

class _ParkingSpaceSelectionScreenState
    extends State<ParkingSpaceSelectionScreen> {
  late Future<List<ParkingSpace>> _parkingSpacesFuture;
  ParkingSpace? _selectedParkingSpace; // To keep track of the selected space

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
        title: const Text("Select a Parking Space"),
      ),
      body: FutureBuilder<List<ParkingSpace>>(
        future: _parkingSpacesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No parking spaces available.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final parkingSpaces = snapshot.data!;
          return Column(
            children: [
              if (_selectedParkingSpace != null)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.green.withOpacity(0.2),
                  child: Text(
                    'Selected Parking Space:\n'
                    'ID: ${_selectedParkingSpace!.id}\n'
                    'Address: ${_selectedParkingSpace!.address}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: parkingSpaces.length,
                  itemBuilder: (context, index) {
                    final parkingSpace = parkingSpaces[index];
                    final isSelected =
                        _selectedParkingSpace?.id == parkingSpace.id;
                    return ListTile(
                      title: Text(
                        'Parking Space ID: ${parkingSpace.id}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address: ${parkingSpace.address}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Price per hour: ${parkingSpace.pricePerHour} SEK',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedParkingSpace = parkingSpace;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? Colors.green : Colors.blue,
                        ),
                        child: Text(isSelected ? "Selected" : "Select"),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
