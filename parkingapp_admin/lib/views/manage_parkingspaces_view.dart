// import 'package:flutter/material.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:shared/shared.dart';
// //import 'package:shared_preferences/shared_preferences.dart';

// class ManageParkingSpacesView extends StatefulWidget {
//   const ManageParkingSpacesView({super.key});

//   @override
//   _ManageParkingSpacesViewState createState() =>
//       _ManageParkingSpacesViewState();
// }

// class _ManageParkingSpacesViewState extends State<ManageParkingSpacesView> {
//   late Future<List<ParkingSpace>> _parkingSpacesFuture;

//   String? loggedInName;
//   String? loggedInPersonNum;

//   @override
//   void initState() {
//     super.initState();
//     //_loadLoggedInUser();
//     _refreshParkingSpaces();
//   }

//   /// Loads all parking spaces from the repository.
//   void _refreshParkingSpaces() {
//     setState(() {
//       _parkingSpacesFuture =
//           ParkingSpaceRepository.instance.getAllParkingSpaces();
//     });
//   }

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
//                 await ParkingSpaceRepository.instance
//                     .deleteParkingSpace(parkingSpace.id);

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
//         //  actions: [
//         // IconButton(
//         //   icon: const Icon(Icons.filter_list),
//         //  onPressed: //_showAvailableParkingSpaces,
//         //      _refreshParkingSpaces,
//         // ),
//         // ],
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
//                 color: Colors.black87,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/parking_space/parking_space_bloc.dart';

class ManageParkingSpacesView extends StatelessWidget {
  const ManageParkingSpacesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingSpaceBloc()
        ..add(LoadParkingSpaces()), // Dispatch initial load event
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Parkeringsplatser"),
        ),
        body: BlocBuilder<ParkingSpaceBloc, ParkingSpacesState>(
          builder: (context, state) {
            if (state is ParkingSpacesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ParkingSpacesError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is ParkingSpacesLoaded) {
              final parkingSpacesList = state.parkingSpaces;
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
                          'Adress: ${parkingSpace.address}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Pris per timme: ${parkingSpace.pricePerHour} SEK',
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
                            // Handle Edit Action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle Delete Action
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
            return const SizedBox.shrink(); // Default case if no state is found
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show add dialog and dispatch AddParkingSpace event
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
