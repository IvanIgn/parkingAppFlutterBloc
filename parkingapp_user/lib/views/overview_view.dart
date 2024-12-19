// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// class OverviewView extends StatefulWidget {
//   const OverviewView({super.key});

//   @override
//   _OverviewViewState createState() => _OverviewViewState();
// }

// class _OverviewViewState extends State<OverviewView> {
//   Vehicle? selectedVehicle;
//   ParkingSpace? selectedParkingSpace;
//   Parking? parkingInstance;
//   //Person? selectedPerson;

//   late Future<void> _loadData;

//   @override
//   void initState() {
//     super.initState();
//     _loadData = _loadDataFromPrefs();
//   }

//   Future<void> _loadDataFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();

//     try {
//       // Load selected vehicle
//       final vehicleJson = prefs.getString('selectedVehicle');
//       if (vehicleJson != null) {
//         selectedVehicle = Vehicle.fromJson(json.decode(vehicleJson));
//         print('Selected Vehicle: $vehicleJson'); // Print vehicle data
//       }

//       // Load selected parking space
//       final parkingSpaceJson = prefs.getString('activeParkingSpace');
//       if (parkingSpaceJson != null) {
//         selectedParkingSpace =
//             ParkingSpace.fromJson(json.decode(parkingSpaceJson));
//         print(
//             'Selected Parking Space: $parkingSpaceJson'); // Print parking space data
//       }

//       // // Load logged in person
//       // final personJson = prefs.getString('loggedInName');
//       // if (personJson != null) {
//       //   selectedPerson = Person.fromJson(json.decode(personJson));
//       //   print('Selected Person: $personJson'); // Print parking space data
//       // }

//       // Create Parking instance if data is valid
//       if (selectedVehicle != null &&
//           selectedVehicle!.id.isNotEmpty &&
//           selectedParkingSpace != null &&
//           selectedParkingSpace!.id.isNotEmpty) {
//         parkingInstance = Parking(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           startTime: DateTime.now(),
//           endTime: DateTime.now().add(const Duration(hours: 2)),
//           vehicle: selectedVehicle!,
//           parkingSpace: selectedParkingSpace!,
//         );

//         // Save the parking instance to SharedPreferences
//         prefs.setString('parking', json.encode(parkingInstance!.toJson()));
//         print(
//             'Created Parking Instance: ${json.encode(parkingInstance!.toJson())}'); // Print parking instance data
//       }
//     } catch (e) {
//       print('Error loading data: $e');
//     }

//     setState(() {}); // Update UI after data is loaded
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Overview"),
//       ),
//       body: FutureBuilder<void>(
//         future: _loadData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           }

//           // If parkingInstance is null
//           if (parkingInstance == null) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.info_outline, size: 50, color: Colors.grey),
//                   SizedBox(height: 16),
//                   Text(
//                     'No parking data found. Please select a vehicle and parking space.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final formattedStartTime =
//               DateFormat('yyyy-MM-dd HH:mm').format(parkingInstance!.startTime);
//           final formattedEndTime =
//               DateFormat('yyyy-MM-dd HH:mm').format(parkingInstance!.endTime);

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildSectionTitle(context, 'Parking Details:'),
//                 const SizedBox(height: 8),
//                 buildKeyValue('Parking ID', parkingInstance!.id),
//                 buildKeyValue('Start Time', formattedStartTime),
//                 buildKeyValue('End Time', formattedEndTime),
//                 const SizedBox(height: 16),
//                 buildSectionTitle(context, 'Vehicle Details:'),
//                 const SizedBox(height: 8),
//                 buildKeyValue('Vehicle ID', parkingInstance!.vehicle.id),
//                 buildKeyValue(
//                     'Registration Number', parkingInstance!.vehicle.regNumber),
//                 buildKeyValue(
//                     'Vehicle Type', parkingInstance!.vehicle.vehicleType),
//                 const SizedBox(height: 16),
//                 buildSectionTitle(context, 'Owner Details:'),
//                 const SizedBox(height: 8),
//                 if (parkingInstance!.vehicle.owner != null) ...[
//                   buildKeyValue(
//                       'Owner Name', parkingInstance!.vehicle.owner!.name),
//                   buildKeyValue('Owner Person Number',
//                       parkingInstance!.vehicle.owner!.personNum),
//                 ] else
//                   const Text('Owner information not available.'),
//                 const SizedBox(height: 16),
//                 buildSectionTitle(context, 'Parking Space Details:'),
//                 const SizedBox(height: 8),
//                 buildKeyValue(
//                     'Parking Space ID', parkingInstance!.parkingSpace.id),
//                 buildKeyValue('Address', parkingInstance!.parkingSpace.address),
//                 buildKeyValue('Price per Hour',
//                     parkingInstance!.parkingSpace.pricePerHour.toString()),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildSectionTitle(BuildContext context, String title) {
//     return Text(
//       title,
//       style: Theme.of(context).textTheme.titleLarge,
//     );
//   }

//   Widget buildKeyValue(String key, String value) {
//     return Text('$key: $value');
//   }
// }

// // Updated Parking class
// // Parking class
// class Parking {
//   final String id;
//   final Vehicle vehicle;
//   final ParkingSpace parkingSpace;
//   final DateTime startTime;
//   final DateTime endTime;

//   Parking({
//     required this.id,
//     required this.vehicle,
//     required this.parkingSpace,
//     required this.startTime,
//     required this.endTime,
//   });

//   factory Parking.fromJson(Map<String, dynamic> json) => Parking(
//         id: json['id'].toString(),
//         vehicle: Vehicle.fromJson(Map<String, dynamic>.from(json['vehicle'])),
//         parkingSpace: ParkingSpace.fromJson(
//             Map<String, dynamic>.from(json['parkingSpace'])),
//         startTime: DateTime.parse(json['startTime'].toString()),
//         endTime: DateTime.parse(json['endTime'].toString()),
//       );

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id.toString(),
//       'vehicle': vehicle.toJson(),
//       'parkingSpace': parkingSpace.toJson(),
//       'startTime': startTime.toIso8601String(),
//       'endTime': endTime.toIso8601String(),
//     };
//   }
// }

// class Vehicle {
//   final String id;
//   final String regNumber;
//   final String vehicleType;
//   final Person? owner;

//   Vehicle({
//     required this.id,
//     required this.regNumber,
//     required this.vehicleType,
//     required this.owner,
//   });

//   factory Vehicle.fromJson(Map<String, dynamic> json) {
//     return Vehicle(
//       id: json['id'].toString(),
//       regNumber: json['regNumber'].toString(),
//       vehicleType: json['vehicleType'].toString(),
//       owner: json['owner'] != null ? Person.fromJson(json['owner']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id.toString(),
//       'regNumber': regNumber.toString(),
//       'vehicleType': vehicleType.toString(),
//       'owner': owner?.toJson(), // Do not use toString(), return object directly
//     };
//   }
// }

// // ParkingSpace class
// class ParkingSpace {
//   final String id;
//   final String address;
//   final int pricePerHour;

//   ParkingSpace({
//     required this.id,
//     required this.address,
//     required this.pricePerHour,
//   });

//   factory ParkingSpace.fromJson(Map<String, dynamic> json) {
//     return ParkingSpace(
//       id: json['id'].toString(),
//       address: json['address'].toString(),
//       pricePerHour: json['pricePerHour'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id.toString(),
//       'address': address.toString(),
//       'pricePerHour': pricePerHour.toString(),
//     };
//   }
// }

// class Person {
//   final String id;
//   final String name;
//   final String personNum;

//   Person({
//     required this.id,
//     required this.name,
//     required this.personNum,
//   });

//   factory Person.fromJson(Map<String, dynamic> json) {
//     return Person(
//       id: json['id'].toString(),
//       name: json['name'].toString(),
//       personNum: json['personNum']?.toString() ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id.toString(),
//       'name': name.toString(),
//       'personNum': personNum.isNotEmpty ? personNum : null,
//     };
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';
import 'package:intl/intl.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  Vehicle? selectedVehicle;
  ParkingSpace? selectedParkingSpace;
  Parking? parkingInstance;

  final ParkingRepository parkingRepository = ParkingRepository.instance;

  late Future<void> _loadData;

  @override
  void initState() {
    super.initState();
    _loadData = _loadAndSaveParkingData();
  }

  Future<void> _loadAndSaveParkingData() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Load selected vehicle
      final vehicleJson = prefs.getString('selectedVehicle');
      if (vehicleJson != null) {
        selectedVehicle = Vehicle.fromJson(json.decode(vehicleJson));
        print('Selected Vehicle: $vehicleJson');
      }

      // Load selected parking space
      final parkingSpaceJson = prefs.getString('activeParkingSpace');
      if (parkingSpaceJson != null) {
        selectedParkingSpace =
            ParkingSpace.fromJson(json.decode(parkingSpaceJson));
        print('Selected Parking Space: $parkingSpaceJson');
      }

      if (selectedVehicle != null && selectedParkingSpace != null) {
        // Create Parking instance
        parkingInstance = Parking(
          id: 0, // Default ID; the server will assign a proper ID
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          vehicle: selectedVehicle!,
          parkingSpace: selectedParkingSpace!,
        );

        // Save the parking instance to SharedPreferences
        prefs.setString('parking', json.encode(parkingInstance!.toJson()));
        print('Saved Parking to SharedPreferences.');

        // Send the parking instance to ParkingRepository
        parkingInstance =
            await parkingRepository.createParking(parkingInstance!);
        print('Saved Parking to ParkingRepository.');
      } else {
        print('Vehicle or Parking Space not selected.');
      }
    } catch (e) {
      print('Error loading or saving parking data: $e');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
      ),
      body: FutureBuilder<void>(
        future: _loadData,
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
          }

          if (parkingInstance == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No parking data found. Please select a vehicle and parking space.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final formattedStartTime =
              DateFormat('yyyy-MM-dd HH:mm').format(parkingInstance!.startTime);
          final formattedEndTime =
              DateFormat('yyyy-MM-dd HH:mm').format(parkingInstance!.endTime);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle(context, 'Parking Details:'),
                const SizedBox(height: 8),
                buildKeyValue('Parking ID', parkingInstance!.id.toString()),
                buildKeyValue('Start Time', formattedStartTime),
                buildKeyValue('End Time', formattedEndTime),
                const SizedBox(height: 16),
                buildSectionTitle(context, 'Vehicle Details:'),
                const SizedBox(height: 8),
                buildKeyValue(
                    'Vehicle ID', parkingInstance!.vehicle!.id.toString()),
                buildKeyValue(
                    'Registration Number', parkingInstance!.vehicle!.regNumber),
                buildKeyValue(
                    'Vehicle Type', parkingInstance!.vehicle!.vehicleType),
                const SizedBox(height: 16),
                buildSectionTitle(context, 'Owner Details:'),
                const SizedBox(height: 8),
                if (parkingInstance!.vehicle!.owner != null) ...[
                  buildKeyValue(
                      'Owner Name', parkingInstance!.vehicle!.owner!.name),
                  buildKeyValue('Owner Person Number',
                      parkingInstance!.vehicle!.owner!.personNumber),
                ] else
                  const Text('Owner information not available.'),
                const SizedBox(height: 16),
                buildSectionTitle(context, 'Parking Space Details:'),
                const SizedBox(height: 8),
                buildKeyValue('Parking Space ID',
                    parkingInstance!.parkingSpace!.id.toString()),
                buildKeyValue(
                    'Address', parkingInstance!.parkingSpace!.address),
                buildKeyValue('Price per Hour',
                    parkingInstance!.parkingSpace!.pricePerHour.toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget buildKeyValue(String key, String value) {
    return Text('$key: $value');
  }
}
