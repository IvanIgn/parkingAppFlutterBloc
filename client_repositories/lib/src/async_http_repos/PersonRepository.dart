import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cli_shared/cli_shared.dart';
//import 'VehicleRepository.dart';

class PersonRepository {
  static final PersonRepository _instance = PersonRepository._internal();
  static PersonRepository get instance => _instance;
  PersonRepository._internal();

  //  static final VehicleRepository _instance = VehicleRepository._internal();
  // static VehicleRepository get instance => _instance;
  // VehicleRepository._internal();

  //final String baseUrl = 'http://localhost:8080/persons'; // Serverns URL

  String host = 'http://localhost';
  String port = '8080';
  String resource = 'persons';

/*
  // Skapa en ny person på servern
  Future<void> addPerson(Person person) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(person.toJson()), // Konvertera Person till JSON
      );

      if (response.statusCode == 201) {
        print('Person ${person.name} added successfully.');
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.body}');
      } else {
        print('Failed to add person: ${response.body}');
      }
    } catch (e) {
      print('Error adding person: $e');
    }
  }

  // Hämta alla personer från servern
  Future<List<Person>> getAllPersons() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Person.fromJson(json)).toList();
      } else {
        print('Failed to load persons: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching persons: $e');
      return [];
    }
  }

  // Hämta en specifik person baserat på personnummer
  Future<Person?> getPersonByPersonNumber(String personNumber) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$personNumber'));

      if (response.statusCode == 200) {
        return Person.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        print('Person not found: $personNumber');
        return null;
      } else {
        print('Failed to load person: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching person: $e');
      return null;
    }
  }

  // Uppdatera en persons data på servern
  Future<void> updatePerson(Person updatedPerson) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${updatedPerson.personNumber}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedPerson.toJson()),
      );

      if (response.statusCode == 200) {
        print('Person ${updatedPerson.name} updated successfully.');
      } else if (response.statusCode == 404) {
        print('Person not found: ${updatedPerson.personNumber}');
      } else {
        print('Failed to update person: ${response.body}');
      }
    } catch (e) {
      print('Error updating person: $e');
    }
  }

  // Ta bort en person från servern
  Future<void> deletePerson(String personNumber) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$personNumber'));

      if (response.statusCode == 200) {
        print('Person with personnummer $personNumber deleted successfully.');
      } else if (response.statusCode == 404) {
        print('Person not found: $personNumber');
      } else {
        print('Failed to delete person: ${response.body}');
      }
    } catch (e) {
      print('Error deleting person: $e');
    }
  }

  */

  Future<dynamic> addPerson(Person person) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()));

    return response;
  }

  Future<dynamic> getAllPersons() async {
    final uri = Uri.parse('$host:$port/$resource');

    final response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    final json = jsonDecode(response.body);

    return (json as List).map((person) => Person.fromJson(person)).toList();
  }

  Future<Person> getPersonById(int id) async {
    final uri = Uri.parse('$host:$port/$resource/$id');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Person.fromJson(json);
  }

  Future<dynamic> updatePersons(Person person) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()));

    return response;
  }

  Future<dynamic> deletePerson(Person person) async {
    final uri = Uri.parse('$host:$port/$resource');

    final response = await http.delete(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()));

    return response;
  }
}
