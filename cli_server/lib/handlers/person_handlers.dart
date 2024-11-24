import 'dart:convert';
import 'package:cli_server/repositories/personRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:shelf/shelf.dart';

const _jsonHeaders = {
  'Content-Type': 'application/json',
};

final personRepo = PersonRepository.instance;

Future<Response> getAllPersonsHandler(Request request) async {
  final persons = await personRepo.getAll();
  return Response.ok(
    jsonEncode(persons?.map((p) => p.toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /persons
Future<Response> createPersonHandler(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final person = Person.fromJson(data);
  personRepo.add(person); // await för asynkron operation
  return Response.ok('Person med ID ${person.personNumber} skapad.');
}

// GET /persons/<id>
Future<Response> getPersonByIdHandler(Request request, String id) async {
  final personId = int.tryParse(id);
  if (personId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  final person = await personRepo.getById(personId);
  if (person != null) {
    return Response.ok(jsonEncode(person.toJson()), headers: _jsonHeaders);
  } else {
    return Response.notFound('Person med ID $id hittades inte.');
  }
}

// PUT /persons/<id>
Future<Response> updatePersonHandler(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedPerson = Person.fromJson(data);
  final personId = int.tryParse(id);
  if (personId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  await personRepo.update(
      personId, updatedPerson); // await för asynkron operation
  return Response.ok('Person med ID $id uppdaterad.');
}

// DELETE /persons/<id>
Future<Response> deletePersonHandler(Request request, String id) async {
  final personId = int.tryParse(id);
  if (personId == null) {
    return Response.badRequest(body: 'Invalid ID format.');
  }
  await personRepo.delete(personId); // await för asynkron operation
  return Response.ok('Person med ID $id har tagits bort.');
}
