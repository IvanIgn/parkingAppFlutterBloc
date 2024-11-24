import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cli_shared/cli_shared.dart';

class ParkingRepository {
  //final String baseUrl = 'http://localhost:8080'; // Serverns URL

  // Singleton-instans av ParkingRepository
  static final ParkingRepository _instance = ParkingRepository._internal();
  static ParkingRepository get instance => _instance;
  ParkingRepository._internal();

  String host = 'http://localhost';
  String port = '8080';
  String resource = 'parkings';

/*
  // Lägga till en ny parkering via HTTP POST-begäran
  Future<void> addParking(Parking parking) async {
    try {
      final url = Uri.parse('$baseUrl/parkings');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parking.toJson()),
      );

      if (response.statusCode == 201) {
        print('Parkering med ID ${parking.id} tillagd.');
      } else if (response.statusCode == 400) {
        print('Ogiltig förfrågan: ${response.body}');
      } else {
        print('Fel vid tillägg av parkering: ${response.body}');
      }
    } catch (e) {
      print('Fel vid tillägg av parkering: $e');
    }
  }

  // Hämta alla parkeringar från servern
  Future<List<Parking>> getAllParkings() async {
    try {
      final url = Uri.parse('$baseUrl/parkings');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Parking.fromJson(json)).toList();
      } else {
        print('Fel vid hämtning av parkeringar: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Fel vid hämtning av parkeringar: $e');
      return [];
    }
  }

  // Hämta en specifik parkering via ID
  Future<Parking?> getParkingById(String id) async {
    try {
      final url = Uri.parse('$baseUrl/parkings/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Parking.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        print('Parkering ej funnet: $id');
        return null;
      } else {
        print('Fel vid hämtning av parkering: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Fel vid hämtning av parkering: $e');
      return null;
    }
  }

  // Uppdatera en parkering via HTTP PUT-begäran
  Future<void> updateParking(String id, Parking updatedParking) async {
    try {
      final url = Uri.parse('$baseUrl/parkings/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedParking.toJson()),
      );

      if (response.statusCode == 200) {
        print('Parkering med ID $id uppdaterad.');
      } else if (response.statusCode == 404) {
        print('Parkering ej funnet: $id');
      } else {
        print('Fel vid uppdatering av parkering: ${response.body}');
      }
    } catch (e) {
      print('Fel vid uppdatering av parkering: $e');
    }
  }

  // Ta bort en parkering via HTTP DELETE-begäran
  Future<void> deleteParking(String id) async {
    try {
      final url = Uri.parse('$baseUrl/parkings/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Parkering med ID $id har tagits bort.');
      } else if (response.statusCode == 404) {
        print('Parkering ej funnet: $id');
      } else {
        print('Fel vid borttagning av parkering: ${response.body}');
      }
    } catch (e) {
      print('Fel vid borttagning av parkering: $e');
    }
  }
  */

  Future<dynamic> addParking(Parking parking) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking));

    return response;
  }

  Future<dynamic> getAllParkings() async {
    final uri = Uri.parse('$host:$port/$resource');

    final response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    final json = jsonDecode(response.body);

    return (json as List)
        .map((parkings) => Parking.fromJson(parkings))
        .toList();
  }

  Future<Parking> getParkingById(int id) async {
    final uri = Uri.parse('$host:$port/$resource/$id');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Parking.fromJson(json);
  }

  Future<dynamic> updateParkings(Parking parking) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJson()));

    return response;
  }

  Future<dynamic> deleteParkings(Parking parking) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.delete(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJson()));

    return response;
  }
}
