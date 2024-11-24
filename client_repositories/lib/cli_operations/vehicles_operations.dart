import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/src/async_http_repos/PersonRepository.dart';
import 'package:cli_client/src/async_http_repos/VehicleRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/utils/validator.dart';

class VehiclesOperations extends SetMainPage {
  final VehicleRepository _vehicleRepository = VehicleRepository.instance;
  final PersonRepository _personRepository = PersonRepository.instance;

  List<String> menuTexts = [
    'Du har valt att hantera Fordon. Vad vill du göra?\n',
    '1. Skapa nytt fordon\n',
    '2. Visa alla fordon\n',
    '3. Uppdatera fordon\n',
    '4. Ta bort fordon\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    try {
      switch (chosenOption) {
        case 1:
          _addVehicleOperation();
          break;
        case 2:
          _showAllVehiclesOperation();
          break;
        case 3:
          _updateVehicleOperation();
          break;
        case 4:
          _deleteVehicleOperation();
          break;
        case 5:
          setMainPage(clearCLI: true);
          return;
        default:
          _printError('Ogiltigt val, vänligen försök igen.');
      }
    } catch (e) {
      _printError('Ett oväntat fel inträffade: ${e.toString()}');
    }
  }

  // Create new vehicle
  Future<void> _addVehicleOperation() async {
    try {
      print('\n--- Skapa nytt fordon ---');
      final regNumber = _promptInput('Ange registreringsnummer:');
      final vehicleType =
          _promptInput('Ange fordonstyp (t.ex., bil, motorcykel):');
      final ownerSSN = _promptInput('Ange ägarens personnummer (valfritt):');

      if (!Validator.isString(regNumber) || !Validator.isString(vehicleType)) {
        _printError('Ogiltig inmatning, fordonet skapades inte.');
        return;
      }

      Person? owner;
      if (ownerSSN != null && Validator.isValidSocialSecurityNumber(ownerSSN)) {
        owner = await _personRepository.getPersonById(int.parse(ownerSSN));
      }

      final vehicle = Vehicle(
        regNumber: regNumber!,
        vehicleType: vehicleType!,
        owner: owner,
      );
      await _vehicleRepository.addVehicle(vehicle);
      print(
          'Fordon med registreringsnummer ${vehicle.regNumber} har lagts till.');
    } catch (e) {
      _printError('Fel vid skapande av fordon: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Show all vehicles
  Future<void> _showAllVehiclesOperation() async {
    try {
      print('\n--- Alla fordon ---');
      final vehicles = await _vehicleRepository.getAllVehicles();

      if (vehicles.isEmpty) {
        print('Inga fordon hittades.');
      } else {
        vehicles.asMap().forEach((index, vehicle) {
          final ownerInfo = vehicle.owner != null
              ? 'Ägare: ${vehicle.owner!.name}, Personnummer: ${vehicle.owner!.personNumber}'
              : 'Ingen ägare';
          print(
              '${index + 1}. Registreringsnummer: ${vehicle.regNumber}, Typ: ${vehicle.vehicleType}, $ownerInfo');
        });
      }
    } catch (e) {
      _printError('Fel vid visning av fordon: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Update vehicle
  Future<void> _updateVehicleOperation() async {
    try {
      print('\n--- Uppdatera fordon ---');
      final regNumber = _promptInput(
          'Ange registreringsnummer för det fordon du vill uppdatera:');

      if (!Validator.isString(regNumber)) {
        _printError('Ogiltig inmatning.');
        return;
      }

      final vehicle =
          await _vehicleRepository.getVehicleById(int.parse(regNumber!));

      final newRegNumber = _promptInput(
          'Nytt registreringsnummer (lämna tomt för att behålla aktuellt):');
      final newVehicleType =
          _promptInput('Ny fordonstyp (lämna tomt för att behålla aktuell):');
      final newOwnerSSN =
          _promptInput('Ange nytt ägarens personnummer (valfritt):');

      if (Validator.isString(newRegNumber) && newRegNumber!.isNotEmpty) {
        vehicle.regNumber = newRegNumber;
      }
      if (Validator.isString(newVehicleType) && newVehicleType!.isNotEmpty) {
        vehicle.vehicleType = newVehicleType;
      }

      if (newOwnerSSN != null &&
          Validator.isValidSocialSecurityNumber(newOwnerSSN)) {
        final newOwner =
            await _personRepository.getPersonById(int.parse(newOwnerSSN));
        vehicle.owner = newOwner;
      }

      await _vehicleRepository.updateVehicles(vehicle);
      print('Fordonet har uppdaterats.');
    } catch (e) {
      _printError('Fel vid uppdatering av fordon: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Delete vehicle
  Future<void> _deleteVehicleOperation() async {
    try {
      print('\n--- Ta bort fordon ---');
      final regNumber = _promptInput(
          'Ange registreringsnummer för det fordon du vill ta bort:');

      if (!Validator.isString(regNumber)) {
        _printError('Ogiltig inmatning.');
        return;
      }

      final vehicle =
          await _vehicleRepository.getVehicleById(int.parse(regNumber!));

      await _vehicleRepository.deleteVehicle(vehicle);
      print(
          'Fordon med registreringsnummer ${vehicle.regNumber} har tagits bort.');
    } catch (e) {
      _printError('Fel vid borttagning av fordon: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Prompt input helper
  static String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  // Error print helper
  static void _printError(String message) {
    print('Fel: $message');
  }
}
