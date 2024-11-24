import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cli_shared/cli_shared.dart';

class VehicleRepository {
  // final String baseUrl = 'http://localhost:8080'; // Serverns URL

  // Singleton-instans av VehicleRepository
  static final VehicleRepository _instance = VehicleRepository._internal();
  static VehicleRepository get instance => _instance;
  VehicleRepository._internal();

  String host = 'http://localhost';
  String port = '8080';
  String resource = 'vehicles';

/*
  // Lägga till ett nytt fordon via HTTP POST-begäran
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      final url = Uri.parse('$baseUrl/vehicles');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(vehicle.toJson()),
      );

      if (response.statusCode == 201) {
        print('Fordon ${vehicle.regNumber} tillagt.');
      } else if (response.statusCode == 400) {
        print('Ogiltig förfrågan: ${response.body}');
      } else {
        print('Fel vid tillägg av fordon: ${response.body}');
      }
    } catch (e) {
      print('Fel vid tillägg av fordon: $e');
    }
  }

  // Hämta alla fordon från servern
  Future<List<Vehicle>> getAllVehicles() async {
    try {
      final url = Uri.parse('$baseUrl/vehicles');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        print('Fel vid hämtning av fordon: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Fel vid hämtning av fordon: $e');
      return [];
    }
  }

  // Hämta ett specifikt fordon via registreringsnummer
  Future<Vehicle?> getVehicleByRegNumber(String registrationNumber) async {
    try {
      final url = Uri.parse('$baseUrl/vehicles/$registrationNumber');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Vehicle.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        print('Fordon ej funnet: $registrationNumber');
        return null;
      } else {
        print('Fel vid hämtning av fordon: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Fel vid hämtning av fordon: $e');
      return null;
    }
  }

  // Uppdatera ett fordon via HTTP PUT-begäran
  Future<void> updateVehicle(
      String registrationNumber, Vehicle updatedVehicle) async {
    try {
      final url = Uri.parse('$baseUrl/vehicles/$registrationNumber');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedVehicle.toJson()),
      );

      if (response.statusCode == 200) {
        print('Fordon ${updatedVehicle.regNumber} uppdaterad.');
      } else if (response.statusCode == 404) {
        print('Fordon ej funnet: $registrationNumber');
      } else {
        print('Fel vid uppdatering av fordon: ${response.body}');
      }
    } catch (e) {
      print('Fel vid uppdatering av fordon: $e');
    }
  }

  // Ta bort ett fordon via HTTP DELETE-begäran
  Future<void> deleteVehicle(String registrationNumber) async {
    try {
      final url = Uri.parse('$baseUrl/vehicles/$registrationNumber');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print(
            'Fordon med registreringsnummer $registrationNumber har tagits bort.');
      } else if (response.statusCode == 404) {
        print('Fordon ej funnet: $registrationNumber');
      } else {
        print('Fel vid borttagning av fordon: ${response.body}');
      }
    } catch (e) {
      print('Fel vid borttagning av fordon: $e');
    }
  }
  */

  Future<dynamic> addVehicle(Vehicle vehicle) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJson()));

    return response;
  }

  Future<dynamic> getAllVehicles() async {
    final uri = Uri.parse('$host:$port/$resource');

    final response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    final json = jsonDecode(response.body);

    return (json as List).map((vehicle) => Vehicle.fromJson(vehicle)).toList();
  }

  Future<Vehicle> getVehicleById(int id) async {
    final uri = Uri.parse('$host:$port/$resource/$id');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJson(json);
  }

  Future<dynamic> updateVehicles(Vehicle vehicle) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJson()));

    return response;
  }

  Future<dynamic> deleteVehicle(Vehicle vehicle) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.delete(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJson()));

    return response;
  }
}
