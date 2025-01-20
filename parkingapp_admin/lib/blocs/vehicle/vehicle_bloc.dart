import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc(this.vehicleRepository) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());
    try {
      final vehicles = await vehicleRepository.getAllVehicles();
      emit(VehicleLoaded(vehicles));
    } catch (error) {
      emit(VehicleError('Failed to load vehicles: $error'));
    }
  }

  Future<void> _onAddVehicle(
    AddVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    if (state is VehicleLoaded) {
      final currentState = state as VehicleLoaded;
      try {
        await vehicleRepository.createVehicle(event.vehicle);
        final updatedVehicles =
            await vehicleRepository.getAllVehicles(); // Refresh list
        emit(VehicleLoaded(updatedVehicles));
      } catch (error) {
        emit(VehicleError('Failed to add vehicle: $error'));
      }
    }
  }

  Future<void> _onUpdateVehicle(
    UpdateVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    if (state is VehicleLoaded) {
      final currentState = state as VehicleLoaded;
      try {
        await vehicleRepository.updateVehicle(event.vehicle.id, event.vehicle);
        final updatedVehicles =
            await vehicleRepository.getAllVehicles(); // Refresh list
        emit(VehicleLoaded(updatedVehicles));
      } catch (error) {
        emit(VehicleError('Failed to update vehicle: $error'));
      }
    }
  }

  Future<void> _onDeleteVehicle(
    DeleteVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    if (state is VehicleLoaded) {
      final currentState = state as VehicleLoaded;
      try {
        await vehicleRepository.deleteVehicle(event.vehicleId);
        final updatedVehicles =
            await vehicleRepository.getAllVehicles(); // Refresh list
        emit(VehicleLoaded(updatedVehicles));
      } catch (error) {
        emit(VehicleError('Failed to delete vehicle: $error'));
      }
    }
  }
}
