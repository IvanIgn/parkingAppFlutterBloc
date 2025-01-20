import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

part 'parking_space_event.dart';
part 'parking_space_state.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  final ParkingSpaceRepository parkingSpaceRepository;

  ParkingSpaceBloc(this.parkingSpaceRepository) : super(ParkingSpaceLoading()) {
    on<LoadParkingSpaces>(_onLoadParkingSpaces);
    on<AddParkingSpace>(_onAddParkingSpace);
    on<UpdateParkingSpace>(_onUpdateParkingSpace);
    on<DeleteParkingSpace>(_onDeleteParkingSpace);
  }

  Future<void> _onLoadParkingSpaces(
    LoadParkingSpaces event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    emit(ParkingSpaceLoading());
    try {
      final parkingSpaces = await parkingSpaceRepository.getAllParkingSpaces();
      emit(ParkingSpaceLoaded(parkingSpaces));
    } catch (e) {
      emit(const ParkingSpaceError("Failed to load parking spaces."));
    }
  }

  Future<void> _onAddParkingSpace(
    AddParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;
      try {
        await parkingSpaceRepository.createParkingSpace(event.parkingSpace);
        final updatedParkingSpaces =
            await parkingSpaceRepository.getAllParkingSpaces(); // Refresh list
        emit(ParkingSpaceLoaded(updatedParkingSpaces));
      } catch (error) {
        emit(ParkingSpaceError('Failed to add parking space: $error'));
      }
    }
  }

  Future<void> _onUpdateParkingSpace(
    UpdateParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;
      try {
        await parkingSpaceRepository.updateParkingSpace(
            event.parkingSpace.id, event.parkingSpace);
        final updatedParkingSpaces =
            await parkingSpaceRepository.getAllParkingSpaces(); // Refresh list
        emit(ParkingSpaceLoaded(updatedParkingSpaces));
      } catch (error) {
        emit(ParkingSpaceError('Failed to update parking space: $error'));
      }
    }
  }

  Future<void> _onDeleteParkingSpace(
    DeleteParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;
      try {
        await parkingSpaceRepository.deleteParkingSpace(event.parkingSpaceId);
        final updatedParkingSpaces =
            await parkingSpaceRepository.getAllParkingSpaces(); // Refresh list
        emit(ParkingSpaceLoaded(updatedParkingSpaces));
      } catch (error) {
        emit(ParkingSpaceError('Failed to delete parking space: $error'));
      }
    }
  }
}
