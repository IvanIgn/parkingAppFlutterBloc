import 'dart:convert';
import 'package:cli_server/repositories/parkingSpaceRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:shelf/shelf.dart';

final parkingSpaceRepo = ParkingSpaceRepository.instance;
const _jsonHeaders = {
  'Content-Type': 'application/json',
};

Future<Response> getAllParkingSpacesHandler(Request request) async {
  final parkingSpaces = await parkingSpaceRepo.getAll();
  return Response.ok(
    jsonEncode(parkingSpaces?.map((p) => p.toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /parkingspaces
Future<Response> createParkingSpaceHandler(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final parkingSpace = ParkingSpace.fromJson(data);
  parkingSpaceRepo.add(parkingSpace); // await för asynkron operation
  return Response.ok('Parkeringsplats med ID ${parkingSpace.id} skapad.');
}

// GET /parkingspaces/<id>
Future<Response> getParkingSpaceByIdHandler(Request request, String id) async {
  final parkingSpace = await parkingSpaceRepo.getById(int.parse(id));
  if (parkingSpace != null) {
    return Response.ok(jsonEncode(parkingSpace.toJson()),
        headers: _jsonHeaders);
  } else {
    return Response.notFound('Parkeringsplats med ID $id hittades inte.');
  }
}

// PUT /parkingspaces/<id>
Future<Response> updateParkingSpaceHandler(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedParkingSpace = ParkingSpace.fromJson(data);
  parkingSpaceRepo.update(
      int.parse(id), updatedParkingSpace); // await för asynkron operation
  return Response.ok('Parkeringsplats med ID $id uppdaterad.');
}

// DELETE /parkingspaces/<id>
Future<Response> deleteParkingSpaceHandler(Request request, String id) async {
  parkingSpaceRepo.delete(int.parse(id)); // await för asynkron operation
  return Response.ok('Parkeringsplats med ID $id har tagits bort.');
}
