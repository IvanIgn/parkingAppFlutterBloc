// parking_space_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';

part 'parking_space_event.dart';
part 'parking_space_state.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpacesEvent, ParkingSpacesState> {
  ParkingSpaceBloc() : super(ParkingSpacesInitial());

  @override
  Stream<ParkingSpacesState> mapEventToState(ParkingSpacesEvent event) async* {
    if (event is LoadParkingSpaces) {
      yield ParkingSpacesLoading();
      try {
        final parkingSpaces =
            await ParkingSpaceRepository.instance.getAllParkingSpaces();
        yield ParkingSpacesLoaded(parkingSpaces);
      } catch (e) {
        yield ParkingSpacesError('Failed to load parking spaces');
      }
    } else if (event is AddParkingSpace) {
      try {
        await ParkingSpaceRepository.instance
            .createParkingSpace(event.parkingSpace);
        yield* _loadParkingSpaces(); // Re-load parking spaces after adding
      } catch (e) {
        yield ParkingSpacesError('Failed to add parking space');
      }
    } else if (event is EditParkingSpace) {
      try {
        await ParkingSpaceRepository.instance
            .updateParkingSpace(event.parkingSpace.id, event.parkingSpace);
        yield* _loadParkingSpaces(); // Re-load parking spaces after editing
      } catch (e) {
        yield ParkingSpacesError('Failed to edit parking space');
      }
    } else if (event is DeleteParkingSpace) {
      try {
        await ParkingSpaceRepository.instance.deleteParkingSpace(event.id);
        yield* _loadParkingSpaces(); // Re-load parking spaces after deletion
      } catch (e) {
        yield ParkingSpacesError('Failed to delete parking space');
      }
    }
  }

  Stream<ParkingSpacesState> _loadParkingSpaces() async* {
    yield ParkingSpacesLoading();
    try {
      final parkingSpaces =
          await ParkingSpaceRepository.instance.getAllParkingSpaces();
      yield ParkingSpacesLoaded(parkingSpaces);
    } catch (e) {
      yield ParkingSpacesError('Failed to load parking spaces');
    }
  }
}
