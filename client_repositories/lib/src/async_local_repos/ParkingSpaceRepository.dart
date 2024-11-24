import 'package:cli_server/cli_server.dart';
//C:\Users\tomas\Desktop\Flutter_projects\parkingappFlutter\cli_server\lib\router_config.dart
import 'package:cli_shared/cli_server_stuff.dart';

class ParkingSpaceRepository {
  // final String baseUrl = 'http://localhost:8080'; // Serverns URL

  // Singleton-instans av ParkingSpaceRepository

  static final ParkingSpaceRepository instance = ParkingSpaceRepository._();

  ParkingSpaceRepository._();

  final Box<ParkingSpace> parkingSpaceBox =
      ServerConfig.instance.store.box<ParkingSpace>();

  Future<ParkingSpace?> add(ParkingSpace item) async {
    parkingSpaceBox.put(item, mode: PutMode.insert);

    // above command did not error
    return item;
  }

  Future<ParkingSpace?> getById(int id) async {
    return parkingSpaceBox.get(id);
  }

  Future<List<ParkingSpace>?> getAll() async {
    return parkingSpaceBox.getAll();
  }

  Future<ParkingSpace?> update(int id, ParkingSpace item) async {
    parkingSpaceBox.put(item, mode: PutMode.update);
    return item;
  }

  Future<ParkingSpace?> delete(int id) async {
    ParkingSpace? item = parkingSpaceBox.get(id);

    if (item != null) {
      parkingSpaceBox.remove(id);
    }

    return item;
  }
}
