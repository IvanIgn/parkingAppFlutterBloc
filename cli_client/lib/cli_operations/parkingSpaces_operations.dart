import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/client_repositories/lib/src/async_local_repos/ParkingSpaceRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/utils/validator.dart';

class ParkingSpaceOperations extends SetMainPage {
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;

  final List<String> menuTexts = [
    'Du har valt att hantera Parkeringsplatser. Vad vill du göra?\n',
    '1. Skapa ny parkeringsplats\n',
    '2. Visa alla parkeringsplatser\n',
    '3. Uppdatera parkeringsplats\n',
    '4. Ta bort parkeringsplats\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    try {
      switch (chosenOption) {
        case 1:
          _addParkingSpaceOperation();
          break;
        case 2:
          _showAllParkingSpacesOperation();
          break;
        case 3:
          _updateParkingSpaceOperation();
          break;
        case 4:
          _deleteParkingSpaceOperation();
          break;
        case 5:
          setMainPage(clearCLI: true);
          return;
        default:
          Validator.printError('Ogiltigt val, försök igen.');
      }
    } catch (e) {
      Validator.printError('Ett oväntat fel inträffade: ${e.toString()}');
    }
  }

  // Add new parking space
  Future<void> _addParkingSpaceOperation() async {
    try {
      print('\n--- Skapa ny parkeringsplats ---');
      final address = _promptInput('Ange adress för parkeringsplatsen:');
      final pricePerHourInput = _promptInput('Ange pris per timme:');

      if (!_isValidAddressAndPrice(address, pricePerHourInput)) return;

      final pricePerHour = double.parse(pricePerHourInput!);
      final parkingSpace = ParkingSpace(
        address: address!,
        pricePerHour: pricePerHour.toInt(),
      );

      await parkingSpaceRepository.addParkingSpace(parkingSpace);
      print('Parkeringsplats på ${parkingSpace.address} har lagts till.');
    } catch (e) {
      Validator.printError(
          'Fel vid skapande av parkeringsplats: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Show all parking spaces
  Future<void> _showAllParkingSpacesOperation() async {
    try {
      print('\n--- Alla parkeringsplatser ---');
      final parkingSpaces = await parkingSpaceRepository.getAllParkingSpaces();

      if (parkingSpaces.isEmpty) {
        print('Inga parkeringsplatser hittades.');
      } else {
        for (var i = 0; i < parkingSpaces.length; i++) {
          final space = parkingSpaces[i];
          print(
              '${i + 1}. Adress: ${space.address}, Pris per timme: ${space.pricePerHour} kr');
        }
      }
    } catch (e) {
      Validator.printError(
          'Fel vid visning av parkeringsplatser: ${e.toString()}');
    } finally {
      _waitForUserInput();
    }
  }

  // Update parking space
  Future<void> _updateParkingSpaceOperation() async {
    try {
      print('\n--- Uppdatera parkeringsplats ---');
      final address = _promptInput(
          'Ange adressen för den parkeringsplats du vill uppdatera:');

      if (!Validator.isString(address)) {
        Validator.printError('Ogiltig adress.');
        return;
      }

      final parkingSpace =
          await parkingSpaceRepository.getParkingSpaceById(int.parse(address!));

      final newAddress =
          _promptInput('Ny adress (lämna tomt för att behålla aktuell):');
      final newPriceInput = _promptInput(
          'Nytt pris per timme (lämna tomt för att behålla aktuellt):');

      if (Validator.isString(newAddress) && newAddress!.isNotEmpty) {
        parkingSpace.address = newAddress;
      }
      if (Validator.isNumber(newPriceInput) && newPriceInput!.isNotEmpty) {
        parkingSpace.pricePerHour = double.parse(newPriceInput).toInt();
      }

      await parkingSpaceRepository.updateParkingSpace(parkingSpace);
      print('Parkeringsplatsen har uppdaterats.');
    } catch (e) {
      Validator.printError(
          'Fel vid uppdatering av parkeringsplats: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Delete parking space
  Future<void> _deleteParkingSpaceOperation() async {
    try {
      print('\n--- Ta bort parkeringsplats ---');
      final address = _promptInput(
          'Ange adressen för den parkeringsplats du vill ta bort:');

      if (!Validator.validateStringInput(address, 'Ogiltig adress.')) return;

      final parkingSpace =
          await parkingSpaceRepository.getParkingSpaceById(int.parse(address!));

      await parkingSpaceRepository.deleteParkingSpace(parkingSpace);
      print('Parkeringsplatsen på ${parkingSpace.address} har tagits bort.');
    } catch (e) {
      Validator.printError(
          'Fel vid borttagning av parkeringsplats: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Helper for input prompts
  String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  // Wait for user input before returning to main menu
  void _waitForUserInput() {
    print('Tryck på valfri tangent för att återgå till huvudmenyn.');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  // Validate address and price input
  bool _isValidAddressAndPrice(String? address, String? pricePerHourInput) {
    if (!Validator.isString(address) ||
        !Validator.isNumber(pricePerHourInput)) {
      Validator.printError('Ogiltig adress eller pris, vänligen försök igen.');
      return false;
    }
    return true;
  }
}
