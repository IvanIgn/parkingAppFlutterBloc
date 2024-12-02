import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared/shared.dart';

class VehicleRepository {
  static final VehicleRepository _instance = VehicleRepository._internal();
  static VehicleRepository get instance => _instance;
  VehicleRepository._internal();

  Future<Vehicle> getVehicleById(int id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJson()));

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final uri = Uri.parse("http://localhost:8080/vehicles");
    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((vehicle) => Vehicle.fromJson(vehicle)).toList();
  }

  Future<Vehicle> deleteVehicle(int id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }

  Future<Vehicle> updateVehicle(int id, Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJson()));

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }
}
