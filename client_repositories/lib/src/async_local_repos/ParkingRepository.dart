//import '../models/Parking.dart' as server_parking;
//import 'package:objectbox/objectbox.dart';

//import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_server_stuff.dart';

//import 'package:cli_shared/cli_shared.dart' as shared;

class ParkingRepository {
  static final ParkingRepository instance = ParkingRepository._();

  ParkingRepository._();

  Box<Parking> parkingBox = ServerConfig.instance.store.box<Parking>();

  Future<Parking?> add(Parking item) async {
    parkingBox.put(item, mode: PutMode.insert);

    // above command did not error
    return item;
  }

  Future<Parking?> getById(int id) async {
    return parkingBox.get(id);
  }

  Future<List<Parking>?> getAll() async {
    return parkingBox.getAll();
  }

  Future<Parking?> update(int id, Parking item) async {
    parkingBox.put(item, mode: PutMode.update);
    return item;
  }

  Future<Parking?> delete(int id) async {
    Parking? item = parkingBox.get(id);

    if (item != null) {
      parkingBox.remove(id);
    }

    return item;
  }
}
