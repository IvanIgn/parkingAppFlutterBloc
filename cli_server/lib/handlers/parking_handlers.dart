import 'dart:convert';
import 'package:cli_server/repositories/parkingRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:shelf/shelf.dart';

final parkingRepo = ParkingRepository.instance;
const _jsonHeaders = {
  'Content-Type': 'application/json',
};

Future<Response> getAllParkingsHandler(Request request) async {
  final parkings = await parkingRepo.getAll();
  return Response.ok(
    jsonEncode(parkings?.map((p) => p.toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /parkings
Future<Response> createParkingHandler(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final parking = Parking.fromJson(data);
  parkingRepo.add(parking); // await för asynkron operation
  return Response.ok('Parkering med ID ${parking.id} skapad.');
}

// GET /parkingspaces/<id>
Future<Response> getParkingByIdHandler(Request request, String id) async {
  final parkingId = int.tryParse(id);
  if (parkingId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  final parking = await parkingRepo.getById(parkingId);
  if (parking != null) {
    return Response.ok(jsonEncode(parking.toJson()), headers: _jsonHeaders);
  } else {
    return Response.notFound('Parkering med ID $id hittades inte.');
  }
}

// PUT /parkings/<id>
Future<Response> updateParkingHandler(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedParking = Parking.fromJson(data);
  final parkingId = int.tryParse(id);
  if (parkingId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  parkingRepo.update(parkingId, updatedParking); // await added
  return Response.ok('Parkering med ID $id uppdaterad.');
}

// DELETE /parkings/<id>
Future<Response> deleteParkingHandler(Request request, String id) async {
  final parkingId = int.tryParse(id);
  if (parkingId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  parkingRepo.delete(parkingId); // await added
  return Response.ok('Parkering med ID $id har tagits bort.');
}
