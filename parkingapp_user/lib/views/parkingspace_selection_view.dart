import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

class ParkingSpaceSelectionScreen extends StatefulWidget {
  const ParkingSpaceSelectionScreen({super.key});

  @override
  _ParkingSpaceSelectionScreenState createState() =>
      _ParkingSpaceSelectionScreenState();
}

class _ParkingSpaceSelectionScreenState
    extends State<ParkingSpaceSelectionScreen> {
  late Future<List<ParkingSpace>> _parkingSpacesFuture;
  ParkingSpace? _selectedParkingSpace; // Tracks the selected parking space

  @override
  void initState() {
    super.initState();
    _loadSelectedParkingSpace(); // Load saved parking space on initialization
    _refreshParkingSpaces();
  }

  Future<void> _loadSelectedParkingSpace() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedParkingSpaceJson = prefs.getString('selectedParkingSpace');

    if (selectedParkingSpaceJson != null) {
      final Map<String, dynamic> parkingSpaceData =
          json.decode(selectedParkingSpaceJson);
      setState(() {
        _selectedParkingSpace = ParkingSpace.fromJson(parkingSpaceData);
      });
    }
  }

  Future<void> _saveSelectedParkingSpace(ParkingSpace parkingSpace) async {
    final prefs = await SharedPreferences.getInstance();
    final parkingSpaceJson = json.encode(parkingSpace.toJson());

    await prefs.setString('selectedParkingSpace', parkingSpaceJson);
    setState(() {
      _selectedParkingSpace = parkingSpace;
    });
  }

  void _refreshParkingSpaces() {
    setState(() {
      _parkingSpacesFuture =
          ParkingSpaceRepository.instance.getAllParkingSpaces();
    });
  }

  void _startParking() {
    if (_selectedParkingSpace != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParkingSessionScreen(
            parkingSpace: _selectedParkingSpace!,
          ),
        ),
      );
    }
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _saveSelectedParkingSpace(parkingSpace);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.green : Colors.blue,
                            ),
                            child: Text(isSelected ? "Selected" : "Select"),
                          ),
                          const SizedBox(width: 10),
                          if (isSelected)
                            ElevatedButton(
                              onPressed: _startParking,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text("Start Parking"),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ParkingSessionScreen extends StatelessWidget {
  final ParkingSpace parkingSpace;

  const ParkingSessionScreen({super.key, required this.parkingSpace});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking Session"),
      ),
      body: Center(
        child: Text(
          'You started parking at:\n'
          'ID: ${parkingSpace.id}\n'
          'Address: ${parkingSpace.address}\n'
          'Price per hour: ${parkingSpace.pricePerHour} SEK',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
