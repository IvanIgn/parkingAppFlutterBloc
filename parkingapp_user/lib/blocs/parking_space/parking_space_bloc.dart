import 'package:bloc/bloc.dart';
import 'package:shared/shared.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

part 'parking_space_event.dart';
part 'parking_space_state.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  final ParkingSpaceRepository parkingSpaceRepository;
  final PersonRepository personRepository;
  final ParkingRepository parkingRepository;
  final VehicleRepository vehicleRepository;
  ParkingSpaceBloc(
      {required this.parkingSpaceRepository,
      required this.parkingRepository,
      required this.personRepository,
      required this.vehicleRepository})
      : super(ParkingSpaceInitial()) {
    on<LoadParkingSpaces>(_onLoadParkingSpaces);
    on<SelectParkingSpace>(_onSelectParkingSpace);
    on<StartParking>(_onStartParking);
    on<StopParking>(_onStopParking);
    on<DeselectParkingSpace>(_onDeselectParkingSpace);
  }

  Future<void> _onLoadParkingSpaces(
    LoadParkingSpaces event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    emit(ParkingSpaceLoading());
    try {
      final parkingSpaces = await parkingSpaceRepository.getAllParkingSpaces();
      final prefs = await SharedPreferences.getInstance();

      // Load selected parking space
      final selectedParkingSpaceJson = prefs.getString('selectedParkingSpace');
      final selectedParkingSpace = selectedParkingSpaceJson != null
          ? ParkingSpace.fromJson(json.decode(selectedParkingSpaceJson))
          : null;

      // Load active parking state
      final isParkingActive = prefs.getBool('isParkingActive') ?? false;

      emit(ParkingSpaceLoaded(
        parkingSpaces: parkingSpaces,
        selectedParkingSpace: selectedParkingSpace,
        isParkingActive: isParkingActive,
      ));
    } catch (e) {
      emit(ParkingSpaceError(e.toString()));
      return;
    }
  }

  Future<void> _onSelectParkingSpace(
    SelectParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final parkingSpaceJson = json.encode(event.parkingSpace.toJson());
    await prefs.setString('selectedParkingSpace', parkingSpaceJson);
    final selectedVehicleJson = prefs.getString('selectedVehicle');

    if (state is ParkingSpaceLoaded && selectedVehicleJson != null) {
      final currentState = state as ParkingSpaceLoaded;
      emit(ParkingSpaceLoaded(
        parkingSpaces: currentState.parkingSpaces,
        selectedParkingSpace: event.parkingSpace,
        isParkingActive: currentState.isParkingActive,
      ));
    }
  }

  Future<void> _onDeselectParkingSpace(
    DeselectParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Clear the selected parking space from shared preferences
    await prefs.remove('selectedParkingSpace');

    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;

      // Emit a new state with `selectedParkingSpace` set to null
      emit(ParkingSpaceLoaded(
        parkingSpaces: currentState.parkingSpaces,
        selectedParkingSpace: null,
        isParkingActive: currentState.isParkingActive,
      ));
    }
  }

  Future<void> _onStartParking(
    StartParking event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      debugPrint('Checking SharedPreferences:');
      debugPrint('loggedInPerson: ${prefs.getString('loggedInPerson')}');
      debugPrint(
          'selectedParkingSpace: ${prefs.getString('selectedParkingSpace')}');
      // debugPrint('selectedVehicle: ${prefs.getString('selectedVehicle')}');

      final selectedParkingSpaceJson = prefs.getString('selectedParkingSpace');
      final selectedVehicleJson = prefs.getString('selectedVehicle');
      final loggedInPersonJson = prefs.getString('loggedInPerson');

      if (selectedParkingSpaceJson == null ||
          selectedVehicleJson == null ||
          loggedInPersonJson == null) {
        throw Exception("Missing required data in SharedPreferences.");
      }

      // Parse JSON data
      final selectedParkingSpace =
          ParkingSpace.fromJson(json.decode(selectedParkingSpaceJson));
      var selectedVehicle = Vehicle.fromJson(json.decode(selectedVehicleJson));
      final loggedInPerson = Person.fromJson(json.decode(loggedInPersonJson));

      final nextPersonId = (await personRepository.getAllPersons()).length + 1;
      selectedVehicle = Vehicle(
        regNumber: selectedVehicle.regNumber,
        vehicleType: selectedVehicle.vehicleType,
        owner: Person(
          id: nextPersonId,
          name: loggedInPerson.name,
          personNumber: loggedInPerson.personNumber,
        ),
      );

      final loggedInPersonName = prefs.getString('loggedInName');
      final loggedInPersonNum = prefs.getString('loggedInPersonNum');

      if (loggedInPersonName != null && loggedInPersonNum != null) {
        // Create a Person object
        var loggedInPerson = Person(
          id: nextPersonId, // Assuming id is 0 or you can set it to any default value
          name: loggedInPersonName,
          personNumber: loggedInPersonNum,
        );

        // Convert the Person object to JSON
        final loggedInPersonJson = json.encode(loggedInPerson.toJson());

        // Save the JSON string to SharedPreferences
        await prefs.setString('loggedInPerson', loggedInPersonJson);

        // Load the JSON string from SharedPreferences

        //  loggedInPerson = Person.fromJson(personData);
      }

      debugPrint('Parsed Objects:');
      debugPrint('Parking Space: $selectedParkingSpace');
      debugPrint('Vehicle: $selectedVehicle');
      debugPrint('Person: $loggedInPerson');

      // Create and validate Parking instance
      final nextParkingId =
          (await parkingRepository.getAllParkings()).length + 1;
      final loadedLoggedInPersonJson = prefs.getString('loggedInPerson');
      loadedLoggedInPersonJson != null
          ? Person.fromJson(json.decode(loadedLoggedInPersonJson)).name
          : '';
      final parkingInstance = Parking(
        id: nextParkingId, // Use the next parking ID
        vehicle: Vehicle(
          id: selectedVehicle.id, // Default to -1 if id is missing
          regNumber: selectedVehicle.regNumber, // Default to empty string
          vehicleType: selectedVehicle.vehicleType, // Default to empty string
          owner: Person(
            id: nextPersonId, //loggedInPerson.id, // Default to -1 if id is missing
            name: loadedLoggedInPersonJson != null
                ? Person.fromJson(json.decode(loadedLoggedInPersonJson)).name
                : '',
            // Default to empty string if name is missing
            personNumber: loadedLoggedInPersonJson != null
                ? Person.fromJson(json.decode(loadedLoggedInPersonJson))
                    .personNumber
                : '', // Default if missing
          ),
        ),
        parkingSpace: selectedParkingSpace,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
      );

      // Save the parking instance to SharedPreferences
      await prefs.setString('parking', json.encode(parkingInstance.toJson()));

      // Add the parking instance to the ParkingRepository
      await ParkingRepository.instance.createParking(parkingInstance);

      // Save the selected parking space to preferences when parking starts
      final parkingSpaceJson = json.encode(selectedParkingSpace!.toJson());
      await prefs.setString('activeParkingSpace', parkingSpaceJson);
      await prefs.setBool('isParkingActive', true);

      if (state is ParkingSpaceLoaded) {
        final currentState = state as ParkingSpaceLoaded;
        emit(ParkingSpaceLoaded(
          parkingSpaces: currentState.parkingSpaces,
          selectedParkingSpace: selectedParkingSpace,
          isParkingActive: true,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _onStartParking: $e');
      debugPrint(stackTrace.toString());
    }
  }

  Future<void> _onStopParking(
    StopParking event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final parkingJson = prefs.getString('parking');

    if (parkingJson == null) return;

    final parkingInstance = Parking.fromJson(json.decode(parkingJson));
    await parkingRepository.deleteParking(parkingInstance.id);
    await prefs.remove('isParkingActive');

    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;
      emit(ParkingSpaceLoaded(
        parkingSpaces: currentState.parkingSpaces,
        selectedParkingSpace: null,
        isParkingActive: false,
      ));
    }
  }
}
