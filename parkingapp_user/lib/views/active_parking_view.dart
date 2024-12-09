// import 'package:flutter/material.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:shared/shared.dart';

// class ActiveParkingView extends StatefulWidget {
//   const ActiveParkingView({super.key});

//   @override
//   _ActiveParkingViewState createState() => _ActiveParkingViewState();
// }

// class _ActiveParkingViewState extends State<ActiveParkingView> {
//   late Future<List<Parking>> _activeParkingsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadActiveParkings();
//   }

//   void _loadActiveParkings() {
//     setState(() {
//       _activeParkingsFuture = ParkingRepository.instance.getAllParkings();
//     });
//   }

//   void _showAddActiveParkingDialog(BuildContext context) {
//     final TextEditingController idController = TextEditingController();
//     final TextEditingController addressController = TextEditingController();
//     final TextEditingController priceController = TextEditingController();

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Lägg till aktiv parkering"),
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
//                 // final newParking = Parking(
//                 //   id: idController.text,
//                 //   address: addressController.text,
//                 //   pricePerHour:
//                 //       (double.tryParse(priceController.text) ?? 0).toInt(),
//                 // );

//                 // await ParkingRepository.instance.createParking(newParking);

//                 Navigator.of(context).pop();
//                 _loadActiveParkings();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditActiveParkingDialog(
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
//           title: const Text("Redigera aktiv parkering"),
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
//                 // final updatedParkingSpace = ParkingSpace(
//                 //   id: parkingSpace.id,
//                 //   address: addressController.text,
//                 //   pricePerHour: (double.tryParse(priceController.text) ??
//                 //           parkingSpace.pricePerHour)
//                 //       .toInt(),
//                 // );

//                 // await ParkingRepository.instance
//                 //     .updateParking(parkingSpace.id, updatedParkingSpace);

//                 Navigator.of(context).pop();
//                 _loadActiveParkings();
//               },
//               child: const Text("Spara"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteActiveParkingDialog(
//       BuildContext context, ParkingSpace parkingSpace) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Bekräfta borttagning"),
//           content: Text(
//             "Är du säker på att du vill ta bort den aktiva parkeringen med ID ${parkingSpace.id}?",
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
//                 _loadActiveParkings();
//               },
//               child: const Text("Ta bort"),
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
//         future: _activeParkingsFuture,
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

//           final activeParkingList = snapshot.data!;
//           return ListView.separated(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: activeParkingList.length,
//             itemBuilder: (context, index) {
//               final parkingSpace = activeParkingList[index];
//               return ListTile(
//                 title: Text(
//                   'Parkering ID: ${parkingSpace.id}',
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
//                           _showEditActiveParkingDialog(context, parkingSpace),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () =>
//                           _showDeleteActiveParkingDialog(context, parkingSpace),
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
//         onPressed: () => _showAddActiveParkingDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
