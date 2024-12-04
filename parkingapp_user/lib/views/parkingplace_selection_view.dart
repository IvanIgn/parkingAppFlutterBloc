import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

class ParkingSpaceSelectionScreen extends StatefulWidget {
  const ParkingSpaceSelectionScreen({super.key});

  @override
  _ParkingSpaceSelectionScreenState createState() =>
      _ParkingSpaceSelectionScreenState();
}

class _ParkingSpaceSelectionScreenState
    extends State<ParkingSpaceSelectionScreen> {
  late Future<List<ParkingSpace>> _parkingSpacesFuture;

  @override
  void initState() {
    super.initState();
    _loadParkingSpaces();
  }

  void _loadParkingSpaces() {
    setState(() {
      _parkingSpacesFuture =
          ParkingSpaceRepository.instance.getAllParkingSpaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parkeringsplatser"),
      ),
      body: FutureBuilder<List<ParkingSpace>>(
        future: _parkingSpacesFuture,
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
                'Inga parkeringsplatser tillgängliga.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final parkingSpacesList = snapshot.data!;
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
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                color: Colors.grey,
              );
            },
          );
        },
      ),
    );
  }
}
