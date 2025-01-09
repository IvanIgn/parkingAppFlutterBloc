// vehicle_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository _vehicleRepository;

  VehicleBloc(this._vehicleRepository) : super(VehicleInitialState());

  @override
  Stream<VehicleState> mapEventToState(VehicleEvent event) async* {
    if (event is FetchVehiclesEvent) {
      yield* _mapFetchVehiclesEventToState();
    } else if (event is AddVehicleEvent) {
      yield* _mapAddVehicleEventToState(event);
    } else if (event is UpdateVehicleEvent) {
      yield* _mapUpdateVehicleEventToState(event);
    } else if (event is DeleteVehicleEvent) {
      yield* _mapDeleteVehicleEventToState(event);
    }
  }

  Stream<VehicleState> _mapFetchVehiclesEventToState() async* {
    yield VehicleLoadingState();
    try {
      final vehicles = await _vehicleRepository.getAllVehicles();
      yield VehicleLoadedState(vehicles);
    } catch (e) {
      yield VehicleErrorState('Failed to fetch vehicles: $e');
    }
  }

  Stream<VehicleState> _mapAddVehicleEventToState(
      AddVehicleEvent event) async* {
    try {
      await _vehicleRepository.createVehicle(event.vehicle);
      yield VehicleAddedState();
      add(FetchVehiclesEvent()); // Refresh the vehicle list
    } catch (e) {
      yield VehicleErrorState('Failed to add vehicle: $e');
    }
  }

  Stream<VehicleState> _mapUpdateVehicleEventToState(
      UpdateVehicleEvent event) async* {
    try {
      await _vehicleRepository.updateVehicle(event.vehicle.id, event.vehicle);
      yield VehicleUpdatedState();
      add(FetchVehiclesEvent()); // Refresh the vehicle list
    } catch (e) {
      yield VehicleErrorState('Failed to update vehicle: $e');
    }
  }

  Stream<VehicleState> _mapDeleteVehicleEventToState(
      DeleteVehicleEvent event) async* {
    try {
      await _vehicleRepository.deleteVehicle(int.parse(event.vehicleId));
      yield VehicleDeletedState();
      add(FetchVehiclesEvent()); // Refresh the vehicle list
    } catch (e) {
      yield VehicleErrorState('Failed to delete vehicle: $e');
    }
  }
}
