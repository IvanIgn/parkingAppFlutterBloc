import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/client_repositories/lib/src/async_local_repos/PersonRepository.dart';
import 'package:cli_client/utils/validator.dart';
import 'package:cli_shared/cli_shared.dart';

class PersonsOperations extends SetMainPage {
  final PersonRepository personRepository = PersonRepository.instance;

  List<String> menuTexts = [
    'Du har valt att hantera Personer. Vad vill du göra?\n',
    '1. Skapa ny person\n',
    '2. Visa alla personer\n',
    '3. Uppdatera person\n',
    '4. Ta bort person\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    try {
      switch (chosenOption) {
        case 1:
          _addPersonOperation();
          break;
        case 2:
          _showAllPersonsOperation();
          break;
        case 3:
          _updatePersonOperation();
          break;
        case 4:
          _deletePersonOperation();
          break;
        case 5:
          setMainPage(clearCLI: true);
          return;
        default:
          printError('Ogiltigt val, vänligen försök igen.');
      }
    } catch (e) {
      printError('Ett oväntat fel inträffade: ${e.toString()}');
    }
  }

  // Add new person
  Future<void> _addPersonOperation() async {
    try {
      print('\n--- Skapa ny person ---');
      final name = _promptInput('Fyll i namn:');
      final ssn = _promptInput('Fyll i personnummer (12 siffror):');

      // if (name == null ||
      //     ssn == null ||
      //     !Validator.isValidSocialSecurityNumber(ssn)) {
      //   printError('Ogiltig inmatning för att skapa person.');
      //   return;
      // }

      if (name == null || !Validator.isString(name)) {
        printError('Ogiltig inmatning för att skapa person.');
        return;
      }

      if (ssn == null || !Validator.isValidSocialSecurityNumber(ssn)) {
        printError('Ogiltig inmatning för personnummer, fyll i 12 siffror.');
        return;
      }

      final person = Person(name: name, personNumber: ssn);
      await personRepository.addPerson(person);
      print('Personen "${person.name}" har lagts till.');
    } catch (e) {
      printError('Fel vid skapande av person: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Show all persons
  Future<void> _showAllPersonsOperation() async {
    try {
      print('\n--- Alla personer ---');
      final persons = await personRepository.getAllPersons();

      if (persons.isEmpty) {
        print('Inga personer hittades.');
      } else {
        for (var person in persons) {
          print(
              'ID: ${person.id}, Namn: ${person.name}, Personnummer: ${person.personNumber}');
        }
      }
    } catch (e) {
      printError('Fel vid visning av personer: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Update a person
  Future<void> _updatePersonOperation() async {
    try {
      print('\n--- Uppdatera person ---');
      final ssn =
          _promptInput('Fyll i personnummer för personen du vill uppdatera:');
      if (ssn == null || !!Validator.isValidSocialSecurityNumber(ssn)) {
        printError('Ogiltigt personnummer.');
        return;
      }

      final personId = int.tryParse(ssn);
      if (personId == null) {
        printError('Ogiltigt personnummer.');
        return;
      }

      final person = await personRepository.getPersonById(personId);

      final newName =
          _promptInput('Nytt namn (lämna tomt för att behålla aktuellt namn):');
      if (newName != null && newName.isNotEmpty) person.name = newName;

      await personRepository.updatePersons(person);
      print('Personen "${person.name}" har uppdaterats.');
    } catch (e) {
      printError('Fel vid uppdatering av person: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Delete a person
  Future<void> _deletePersonOperation() async {
    try {
      print('\n--- Ta bort person ---');
      final ssn = _promptInput('Fyll i personnummer för att ta bort:');
      if (ssn == null || !!Validator.isValidSocialSecurityNumber(ssn)) {
        printError('Ogiltigt personnummer.');
        return;
      }

      final person = await personRepository.getPersonById(int.parse(ssn));

      await personRepository.deletePerson(person);
      print('Person med personnummer ${person.personNumber} har tagits bort.');
    } catch (e) {
      printError('Fel vid borttagning av person: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Helper for user input prompt
  String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  // Helper for error messages
  void printError(String message) {
    print('Fel: $message');
  }

  // Helper function to validate social security number
  // bool _isValidSSN(String ssn) {
  //   final regex = RegExp(r'^\d{12}$');
  //   return regex.hasMatch(ssn);
  // }
}
