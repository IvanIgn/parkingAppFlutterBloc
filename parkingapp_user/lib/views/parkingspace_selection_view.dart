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
  bool _isParkingActive = false; // Tracks if parking has started

  @override
  void initState() {
    super.initState();
    _loadSelectedParkingSpace(); // Load saved parking space on initialization
    _refreshParkingSpaces();
  }

  // Future<void> _loadSelectedParkingSpace() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final selectedParkingSpaceJson = prefs.getString('selectedParkingSpace');

  //   if (selectedParkingSpaceJson != null) {
  //     final Map<String, dynamic> parkingSpaceData =
  //         json.decode(selectedParkingSpaceJson);
  //     setState(() {
  //       _selectedParkingSpace = ParkingSpace.fromJson(parkingSpaceData);
  //     });
  //   }
  // }

  Future<void> _loadSelectedParkingSpace() async {
    final prefs = await SharedPreferences.getInstance();

    // Load selected parking space
    final selectedParkingSpaceJson = prefs.getString('selectedParkingSpace');
    if (selectedParkingSpaceJson != null) {
      final Map<String, dynamic> parkingSpaceData =
          json.decode(selectedParkingSpaceJson);
      setState(() {
        _selectedParkingSpace = ParkingSpace.fromJson(parkingSpaceData);
      });
    }

    // Load active parking state
    final activeParkingJson = prefs.getString('activeParkingSpace');
    final isParkingActive = prefs.getBool('isParkingActive') ?? false;

    if (activeParkingJson != null && isParkingActive) {
      final Map<String, dynamic> activeParkingData =
          json.decode(activeParkingJson);
      setState(() {
        _selectedParkingSpace = ParkingSpace.fromJson(activeParkingData);
        _isParkingActive = true;
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

  // void _toggleParkingState() {
  //   setState(() {
  //     _isParkingActive = !_isParkingActive; // Toggle parking state
  //   });
  // }

  void _clearSelectedParkingSpace() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedParkingSpace');
    setState(() {
      _selectedParkingSpace = null;
      _isParkingActive = false;
    });
  }

  void _toggleParkingState() async {
    if (_selectedParkingSpace == null) return;

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isParkingActive = !_isParkingActive; // Toggle parking state
    });

    if (_isParkingActive) {
      // Save the selected parking space to preferences when parking starts
      final parkingSpaceJson = json.encode(_selectedParkingSpace!.toJson());
      await prefs.setString('activeParkingSpace', parkingSpaceJson);
      await prefs.setBool('isParkingActive', true);
    } else {
      // Clear parking data when parking stops
      await prefs.remove('activeParkingSpace');
      await prefs.setBool('isParkingActive', false);
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
                  color: _isParkingActive
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  child: Text(
                    _isParkingActive
                        ? 'You started parking at:\n'
                            'ID: ${_selectedParkingSpace!.id}\n'
                            'Address: ${_selectedParkingSpace!.address}\n'
                            'Price per hour: ${_selectedParkingSpace!.pricePerHour} SEK'
                        : 'Selected Parking Space:\n'
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
                      // trailing: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         _saveSelectedParkingSpace(parkingSpace);
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor:
                      //             isSelected ? Colors.green : Colors.blue,
                      //       ),
                      //       child: Text(isSelected ? "Selected" : "Select"),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     if (isSelected)
                      //       ElevatedButton(
                      //         onPressed: _toggleParkingState,
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: _isParkingActive
                      //               ? Colors.red
                      //               : Colors.orange,
                      //         ),
                      //         child: Text(_isParkingActive
                      //             ? "Stop Parking"
                      //             : "Start Parking"),
                      //       ),
                      //   ],
                      // ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (isSelected) {
                                // If the parking space is already selected, deselect it
                                _clearSelectedParkingSpace();
                              } else {
                                // Select the parking space
                                _saveSelectedParkingSpace(parkingSpace);
                              }
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
                              onPressed: _toggleParkingState,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isParkingActive
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                              child: Text(_isParkingActive
                                  ? "Stop Parking"
                                  : "Start Parking"),
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
