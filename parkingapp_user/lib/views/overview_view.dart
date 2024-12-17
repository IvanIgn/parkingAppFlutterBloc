import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:client_repositories/async_http_repos.dart';
//import 'package:shared/shared.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  String? loggedInName;
  String? loggedInPersonNum;
  Vehicle? selectedVehicle;
  ParkingSpace? selectedParkingSpace;

  late Future<List<Parking>> _parkingsFuture;
  final List<Parking> _dynamicParkings =
      []; // List to hold dynamically added parkings

  @override
  void initState() {
    super.initState();
    _parkingsFuture = _loadData();
  }

  Future<List<Parking>> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load logged-in user information
    // final personJson = prefs.getString('loggedInName').toString();
    // loggedInPersonNum = prefs.getString('loggedInPersonNum').toString();
    // if (personJson != null && loggedInPersonNum != null) {
    //   loggedInName = json.decode(personJson)['name'];
    //   loggedInPersonNum = json.decode(personJson)['personNumber'];
    // }

    // Load selected vehicle
    final vehicleJson = prefs.getString('_selectedVehicle');
    if (vehicleJson != null) {
      selectedVehicle = Vehicle.fromJson(json.decode(vehicleJson));
    }

    // Load selected parking space
    final parkingSpaceJson = prefs.getString('activeParkingSpace');
    if (parkingSpaceJson != null) {
      selectedParkingSpace =
          ParkingSpace.fromJson(json.decode(parkingSpaceJson));
    }

    // Prepopulate with sample data for demonstration
    final staticParkings = [
      Parking(
        id: '1',
        startTime: '08:00',
        endTime: '10:00',
        vehicle: Vehicle(id: '1', regNumber: 'ABC123', vehicleType: 'Car'),
        parkingSpace:
            ParkingSpace(id: '1', address: 'Main Street 123', pricePerHour: 20),
      ),
    ];

    // Add dynamic parking entry based on logged-in info, selected vehicle, and space
    if (selectedVehicle != null && selectedParkingSpace != null) {
      final newDynamicParking = Parking(
        id: '0', // Unique ID based on timestamp
        startTime: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Replace with actual start time logic
        endTime: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Replace with actual end time logic
        vehicle: selectedVehicle,
        parkingSpace: selectedParkingSpace,
      );
      _dynamicParkings.add(newDynamicParking);
    }

    return _dynamicParkings; //+ staticParkings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
      ),
      body: FutureBuilder<List<Parking>>(
        future: _parkingsFuture,
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

          // Combine static and dynamic parkings
          final parkingsList = [
            //  ...snapshot.data ?? [],
            ..._dynamicParkings,
          ];

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
              );
            },
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
              color: Colors.black87,
            ),
          );
        },
      ),
    );
  }
}

// Model classes
// class Person {
//   final String id;
//   final String name;
//   final String personNumber;

//   Person({required this.id, required this.name, required this.personNumber});

//   factory Person.fromJson(Map<String, dynamic> json) {
//     return Person(
//       id: json['id'],
//       name: json['name'],
//       personNumber: json['personNumber'],
//     );
//   }
// }

class Vehicle {
  final String id;
  final String regNumber;
  final String vehicleType;

  Vehicle(
      {required this.id, required this.regNumber, required this.vehicleType});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      regNumber: json['regNumber'],
      vehicleType: json['vehicleType'],
    );
  }
}

class ParkingSpace {
  final String id;
  final String address;
  final double pricePerHour;

  ParkingSpace(
      {required this.id, required this.address, required this.pricePerHour});

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'],
      address: json['address'],
      pricePerHour: json['pricePerHour'],
    );
  }
}

class Parking {
  final String id;
  final String startTime;
  final String endTime;
  final Vehicle? vehicle;
  final ParkingSpace? parkingSpace;

  Parking({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.vehicle,
    this.parkingSpace,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      parkingSpace: json['parkingSpace'] != null
          ? ParkingSpace.fromJson(json['parkingSpace'])
          : null,
    );
  }
}
