import 'package:flutter/material.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

class MonitorParkingView extends StatefulWidget {
  const MonitorParkingView({super.key});

  @override
  _MonitorParkingViewState createState() => _MonitorParkingViewState();
}

class _MonitorParkingViewState extends State<MonitorParkingView> {
  late Future<List<Parking>> _parkingsFuture;

  @override
  void initState() {
    super.initState();
    _refreshParkings();
  }

  void _refreshParkings() {
    setState(() {
      _parkingsFuture = ParkingRepository.instance.getAllParkings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hantera Aktiva Parkeringar"),
      ),
      body: FutureBuilder<List<Parking>>(
        future: _parkingsFuture,
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
                'Inga aktiva parkeringar tillgängliga.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final parkingsList = snapshot.data!;
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, parking);
                  },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddParkingDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddParkingDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController startTimeController = TextEditingController();
    final TextEditingController endTimeController = TextEditingController();
    final TextEditingController regNumController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Skapa ny parkering"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Parkerings-ID',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Starttid (yyyy-mm-dd hh:mm:ss)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Sluttid (yyyy-mm-dd hh:mm:ss)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: regNumController,
                  decoration: const InputDecoration(
                    labelText: 'Fordonsnummer',
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Adress',
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
                Parking newParking = Parking(
                  id: int.parse(idController.text),
                  startTime: DateTime.parse(startTimeController.text),
                  endTime: DateTime.parse(endTimeController.text),
                  vehicle: Vehicle(
                      regNumber: regNumController.text,
                      vehicleType:
                          'Car'), // Replace 'Car' with the appropriate vehicle type
                  parkingSpace: ParkingSpace(
                    address: addressController.text,
                    pricePerHour: 0, // Replace 0 with the appropriate value
                  ),
                );

                await ParkingRepository.instance.createParking(newParking);

                Navigator.of(context).pop();
                _refreshParkings();
              },
              child: const Text("Spara"),
            ),
          ],
        );
      },
    );
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
                await ParkingRepository.instance.deleteParking(parking.id);

                Navigator.of(context).pop();
                _refreshParkings();
              },
              child: const Text("Ta bort"),
            ),
          ],
        );
      },
    );
  }
}
