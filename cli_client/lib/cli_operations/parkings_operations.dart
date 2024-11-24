import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/client_repositories/lib/src/async_local_repos/ParkingRepository.dart';
import 'package:cli_client/client_repositories/lib/src/async_local_repos/ParkingSpaceRepository.dart';
import 'package:cli_client/client_repositories/lib/src/async_local_repos/VehicleRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import '../utils/validator.dart';

class ParkingsOperations extends SetMainPage {
  final ParkingRepository parkingRepository = ParkingRepository.instance;
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;
  final VehicleRepository vehicleRepository = VehicleRepository.instance;

  final List<String> menuTexts = [
    'Du har valt att hantera Parkeringar. Vad vill du göra?\n',
    '1. Skapa ny parkering\n',
    '2. Visa alla parkeringar\n',
    '3. Uppdatera parkering\n',
    '4. Ta bort parkering\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    try {
      switch (chosenOption) {
        case 1:
          _addParkingOperation();
          break;
        case 2:
          _showAllParkingsOperation();
          break;
        case 3:
          _updateParkingOperation();
          break;
        case 4:
          _deleteParkingOperation();
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

  // Add new parking entry
  Future<void> _addParkingOperation() async {
    try {
      print('\n--- Skapa ny parkering ---');
      final regNumber = _promptInput('Ange registreringsnummer för fordonet:');
      final parkingAddress = _promptInput('Ange adress för parkeringsplatsen:');
      final startTimeInput = _promptInput('Ange starttid (yyyy-mm-dd hh:mm):');
      final endTimeInput = _promptInput('Ange sluttid (yyyy-mm-dd hh:mm):');

      if ([regNumber, parkingAddress, startTimeInput, endTimeInput]
          .contains(null)) {
        _printError('Alla fält måste fyllas i.');
        return;
      }

      final vehicleId = int.tryParse(regNumber!);
      if (vehicleId == null) {
        _printError('Ogiltigt registreringsnummer.');
        return;
      }
      final vehicle = await vehicleRepository.getVehicleById(vehicleId);

      final parkingSpaceId = int.tryParse(parkingAddress!);
      if (parkingSpaceId == null) {
        _printError('Ogiltig parkeringsplatsadress.');
        return;
      }
      final parkingSpace =
          await parkingSpaceRepository.getParkingSpaceById(parkingSpaceId);

      final startTime = DateTime.tryParse(startTimeInput!);
      final endTime = DateTime.tryParse(endTimeInput!);
      if (startTime == null || endTime == null) {
        _printError('Ogiltigt tidsformat.');
        return;
      }
      if (endTime.isBefore(startTime)) {
        _printError('Sluttiden kan inte vara före starttiden.');
        return;
      }

      final parking = Parking(
        vehicle: vehicle,
        parkingSpace: parkingSpace,
        startTime: startTime,
        endTime: endTime,
      );

      await parkingRepository.addParking(parking);
      print(
          'Parkering tillagd för fordon ${vehicle.regNumber} på ${parkingSpace.address}.');
    } catch (e) {
      _printError('Fel vid skapande av parkering: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Show all parking entries
  Future<void> _showAllParkingsOperation() async {
    try {
      print('\n--- Alla parkeringar ---');
      final parkings = await parkingRepository.getAllParkings();

      if (parkings.isEmpty) {
        print('Inga parkeringar hittades.');
      } else {
        for (var parking in parkings) {
          print(
              'Fordon: ${parking.vehicle?.regNumber}, Adress: ${parking.parkingSpace?.address}, '
              'Starttid: ${parking.startTime}, Sluttid: ${parking.endTime}');
        }
      }
    } catch (e) {
      _printError('Fel vid visning av parkeringar: ${e.toString()}');
    } finally {
      _waitForUserInput();
    }
  }

  // Update a parking entry
  Future<void> _updateParkingOperation() async {
    try {
      print('\n--- Uppdatera parkering ---');
      final regNumber = _promptInput(
          'Ange registreringsnummer för fordonet du vill uppdatera (ex.ABC123):');

      if (regNumber == null ||
          !Validator.isValidSocialSecurityNumber(regNumber)) {
        _printError(
            'Registreringsnummer har fel format, den måste vara ex. ABC123.');
        return;
      }

      final vehicleId = int.tryParse(regNumber);
      if (vehicleId == null) {
        _printError('Ogiltigt registreringsnummer.');
        return;
      }
      final parking = await parkingRepository.getParkingById(vehicleId);

      final newStartTimeInput = _promptInput(
          'Ny starttid (yyyy-mm-dd hh:mm, lämna tomt för att behålla aktuell):');
      final newEndTimeInput = _promptInput(
          'Ny sluttid (yyyy-mm-dd hh:mm, lämna tomt för att behålla aktuell):');

      if (newStartTimeInput != null) {
        parking.startTime =
            DateTime.tryParse(newStartTimeInput) ?? parking.startTime;
      }
      if (newEndTimeInput != null) {
        final newEndTime = DateTime.tryParse(newEndTimeInput);
        if (newEndTime != null && newEndTime.isAfter(parking.startTime)) {
          parking.endTime = newEndTime;
        } else {
          _printError('Ogiltig sluttid.');
        }
      }

      await parkingRepository.updateParkings(parking);
      print(
          'Parkeringen för fordon ${parking.vehicle?.regNumber} har uppdaterats.');
    } catch (e) {
      _printError('Fel vid uppdatering av parkering: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Delete a parking entry
  Future<void> _deleteParkingOperation() async {
    try {
      print('\n--- Ta bort parkering ---');
      final regNumber =
          _promptInput('Ange registreringsnummer för att ta bort parkeringen:');

      if (regNumber == null) {
        _printError('Registreringsnummer krävs.');
        return;
      }

      final vehicleId = int.tryParse(regNumber);
      if (vehicleId == null) {
        _printError('Ogiltigt registreringsnummer.');
        return;
      }
      final parking = await parkingRepository.getParkingById(vehicleId);
      await parkingRepository.deleteParkings(parking);
      print(
          'Parkeringen för fordon ${parking.vehicle?.regNumber} har tagits bort.');
    } catch (e) {
      _printError('Fel vid borttagning av parkering: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  void _waitForUserInput() {
    print('Tryck på valfri tangent för att återgå till huvudmenyn.');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  void _printError(String message) {
    print('Fel: $message');
  }
}
