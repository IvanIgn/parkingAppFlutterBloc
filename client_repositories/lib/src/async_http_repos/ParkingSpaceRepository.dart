import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared/shared.dart';

class ParkingSpaceRepository {
  static final ParkingSpaceRepository _instance =
      ParkingSpaceRepository._internal();
  static ParkingSpaceRepository get instance => _instance;
  ParkingSpaceRepository._internal();

  Future<ParkingSpace> getParkingSpaceById(int id) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces/$id");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJson(json);
  }

  Future<ParkingSpace> createParkingSpace(ParkingSpace parkingspace) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingspace.toJson()));

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJson(json);
  }

  Future<List<ParkingSpace>> getAllParkingSpaces() async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces");
    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List)
        .map((parkingspace) => ParkingSpace.fromJson(parkingspace))
        .toList();
  }

  Future<ParkingSpace> deleteParkingSpace(int id) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces/$id");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJson(json);
  }

  Future<ParkingSpace> updateParkingSpace(
      int id, ParkingSpace parkingspace) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces/$id");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingspace.toJson()));

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJson(json);
  }
}
