import 'package:cli_server/handlers/person_handlers.dart';
import 'package:cli_server/handlers/parking_handlers.dart';
import 'package:cli_server/handlers/parkingSpace_handlers.dart';
import 'package:cli_server/handlers/vehicle_handlers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:cli_shared/cli_server_stuff.dart';

class ServerConfig {
  // singleton constructor

  ServerConfig._privateConstructor() {
    initializer();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Store store;

  late Router router;

  initializer() {
    // Configure routes.
    router = Router();

    store = openStore();

    router.get('/persons', getAllPersonsHandler);
    router.get('/persons/<id>', getPersonByIdHandler);
    router.post('/persons', createPersonHandler);
    router.put('/persons', updatePersonHandler);
    router.delete('/persons', deletePersonHandler);

    router.get('/vehicles', getAllVehiclesHandler);
    router.get('/vehicles/<id>', getVehicleByIdHandler);
    router.post('/vehicles', createVehicleHandler);
    router.put('/vehicles', updateVehicleHandler);
    router.delete('/vehicles', deleteVehicleHandler);

    router.get('/parkingSpaces', getAllParkingSpacesHandler);
    router.get('/parkingSpaces/<id>', getParkingSpaceByIdHandler);
    router.post('/parkingSpaces', createParkingSpaceHandler);
    router.put('/parkingSpaces', updateParkingSpaceHandler);
    router.delete('/parkingSpaces', deleteParkingSpaceHandler);

    router.get('/parkings', getAllParkingsHandler);
    router.get('/parkings/<id>', getParkingByIdHandler);
    router.post('/parkings', createParkingHandler);
    router.put('/parkings', updateParkingHandler);
    router.delete('/parkings', deleteParkingHandler);
  }
}
