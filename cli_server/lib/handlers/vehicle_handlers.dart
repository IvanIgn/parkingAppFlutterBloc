import 'dart:convert';
import 'package:cli_server/repositories/vehicleRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:shelf/shelf.dart';

final vehicleRepo = VehicleRepository.instance;
const _jsonHeaders = {
  'Content-Type': 'application/json',
};

Future<Response> getAllVehiclesHandler(Request request) async {
  final vehicles = await vehicleRepo.getAll();
  return Response.ok(
    jsonEncode(vehicles?.map((v) => (v).toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /vehicles
Future<Response> createVehicleHandler(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final vehicle = Vehicle.fromJson(data);
  vehicleRepo.add(vehicle); // await för asynkron operation
  return Response.ok(
      'Fordon med registreringsnummer ${vehicle.regNumber} skapad.');
}

// GET /vehicles/<id>
Future<Response> getVehicleByIdHandler(Request request, String id) async {
  final vehicleId = int.tryParse(id);
  if (vehicleId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  final vehicle = await vehicleRepo.getById(vehicleId);
  if (vehicle != null) {
    return Response.ok(jsonEncode(vehicle.toJson()), headers: _jsonHeaders);
  } else {
    return Response.notFound('Fordon med ID $id hittades inte.');
  }
}

// PUT /vehicles/<id>
Future<Response> updateVehicleHandler(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedVehicle = Vehicle.fromJson(data);
  final vehicleId = int.tryParse(id);
  if (vehicleId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  vehicleRepo.update(vehicleId, updatedVehicle); // await för asynkron operation
  return Response.ok('Fordon med ID $id uppdaterad.');
}

// DELETE /vehicles/<id>
Future<Response> deleteVehicleHandler(Request request, String id) async {
  final vehicleId = int.tryParse(id);
  if (vehicleId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  vehicleRepo.delete(vehicleId); // await för asynkron operation
  return Response.ok('Fordon med ID $id har tagits bort.');
}
