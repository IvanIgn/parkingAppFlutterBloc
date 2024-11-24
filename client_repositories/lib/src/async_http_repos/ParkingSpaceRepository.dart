import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cli_shared/cli_shared.dart';

class ParkingSpaceRepository {
  // final String baseUrl = 'http://localhost:8080'; // Serverns URL

  String host = 'http://localhost';
  String port = '8080';
  String resource = 'parkingSpaces';

  // Singleton-instans av ParkingSpaceRepository
  static final ParkingSpaceRepository _instance =
      ParkingSpaceRepository._internal();
  static ParkingSpaceRepository get instance => _instance;
  ParkingSpaceRepository._internal();

/*
  // Lägga till en ny parkeringsplats via HTTP POST-begäran
  Future<void> addParkingSpace(ParkingSpace parkingSpace) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parkingSpace.toJson()),
      );

      if (response.statusCode == 201) {
        print('Parkeringsplats med ID ${parkingSpace.id} tillagd.');
      } else if (response.statusCode == 400) {
        print('Ogiltig förfrågan: ${response.body}');
      } else {
        print('Fel vid tillägg av parkeringsplats: ${response.body}');
      }
    } catch (e) {
      print('Fel vid tillägg av parkeringsplats: $e');
    }
  }

  // Hämta alla parkeringsplatser från servern
  Future<List<ParkingSpace>> getAllParkingSpaces() async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ParkingSpace.fromJson(json)).toList();
      } else {
        print('Fel vid hämtning av parkeringsplatser: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Fel vid hämtning av parkeringsplatser: $e');
      return [];
    }
  }

  // Hämta en specifik parkeringsplats via ID
  Future<ParkingSpace?> getParkingSpaceById(String id) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return ParkingSpace.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        print('Parkeringsplats ej funnen: $id');
        return null;
      } else {
        print('Fel vid hämtning av parkeringsplats: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Fel vid hämtning av parkeringsplats: $e');
      return null;
    }
  }

  // Uppdatera en parkeringsplats via HTTP PUT-begäran
  Future<void> updateParkingSpace(
      String id, ParkingSpace updatedParkingSpace) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedParkingSpace.toJson()),
      );

      if (response.statusCode == 200) {
        print('Parkeringsplats med ID $id uppdaterad.');
      } else if (response.statusCode == 404) {
        print('Parkeringsplats ej funnen: $id');
      } else {
        print('Fel vid uppdatering av parkeringsplats: ${response.body}');
      }
    } catch (e) {
      print('Fel vid uppdatering av parkeringsplats: $e');
    }
  }

  // Ta bort en parkeringsplats via HTTP DELETE-begäran
  Future<void> deleteParkingSpace(String id) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Parkeringsplats med ID $id har tagits bort.');
      } else if (response.statusCode == 404) {
        print('Parkeringsplats ej funnen: $id');
      } else {
        print('Fel vid borttagning av parkeringsplats: ${response.body}');
      }
    } catch (e) {
      print('Fel vid borttagning av parkeringsplats: $e');
    }
  }

  */

  Future<dynamic> addParkingSpace(ParkingSpace parkingSpace) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJson()));

    return response;
  }

  Future<dynamic> getAllParkingSpaces() async {
    final uri = Uri.parse('$host:$port/$resource');

    final response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    final json = jsonDecode(response.body);

    return (json as List)
        .map((parkingSpaces) => ParkingSpace.fromJson(parkingSpaces))
        .toList();
  }

  Future<ParkingSpace> getParkingSpaceById(int id) async {
    final uri = Uri.parse('$host:$port/$resource/$id');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJson(json);
  }

  Future<dynamic> updateParkingSpace(ParkingSpace parkingSpace) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJson()));

    return response;
  }

  Future<dynamic> deleteParkingSpace(ParkingSpace parkingSpace) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.delete(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJson()));

    return response;
  }
}
