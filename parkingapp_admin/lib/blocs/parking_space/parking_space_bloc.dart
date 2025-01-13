// parking_space_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';
import 'package:equatable/equatable.dart';

part 'parking_space_event.dart';
part 'parking_space_state.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  final ParkingSpaceRepository parkingSpaceRepository;

  ParkingSpaceBloc(this.parkingSpaceRepository) : super(ParkingSpaceInitial()) {
    on<LoadParkingSpaces>(_onLoadParkingSpaces);
    on<AddParkingSpace>(_onAddParkingSpace);
    on<UpdateParkingSpace>(_onUpdateParkingSpace);
    on<DeleteParkingSpace>(_onDeleteParkingSpace);
  }

  Future<void> _onLoadParkingSpaces(
      LoadParkingSpaces event, Emitter<ParkingSpaceState> emit) async {
    emit(ParkingSpaceLoading());
    try {
      final parkingSpaces = await parkingSpaceRepository.getAllParkingSpaces();
      emit(ParkingSpaceLoaded(parkingSpaces));
    } catch (error) {
      emit(ParkingSpaceError('Failed to load parking spaces: $error'));
    }
  }

  Future<void> _onAddParkingSpace(
      AddParkingSpace event, Emitter<ParkingSpaceState> emit) async {
    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;
      try {
        await parkingSpaceRepository.createParkingSpace(event.parkingSpace);
        final updatedSpaces = List.of(currentState.parkingSpaces)
          ..add(event.parkingSpace);
        emit(ParkingSpaceLoaded(updatedSpaces));
      } catch (error) {
        emit(ParkingSpaceError('Failed to add parking space: $error'));
      }
    }
  }

  Future<void> _onUpdateParkingSpace(
      UpdateParkingSpace event, Emitter<ParkingSpaceState> emit) async {
    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;
      try {
        await parkingSpaceRepository.updateParkingSpace(
            event.id, event.updatedParkingSpace);
        final updatedSpaces = currentState.parkingSpaces.map((space) {
          return space.id == event.id ? event.updatedParkingSpace : space;
        }).toList();
        emit(ParkingSpaceLoaded(updatedSpaces));
      } catch (error) {
        emit(ParkingSpaceError('Failed to update parking space: $error'));
      }
    }
  }

  Future<void> _onDeleteParkingSpace(
      DeleteParkingSpace event, Emitter<ParkingSpaceState> emit) async {
    if (state is ParkingSpaceLoaded) {
      final currentState = state as ParkingSpaceLoaded;
      try {
        await parkingSpaceRepository.deleteParkingSpace(event.id);
        final updatedSpaces = currentState.parkingSpaces
            .where((space) => space.id != event.id)
            .toList();
        emit(ParkingSpaceLoaded(updatedSpaces));
      } catch (error) {
        emit(ParkingSpaceError('Failed to delete parking space: $error'));
      }
    }
  }
}
