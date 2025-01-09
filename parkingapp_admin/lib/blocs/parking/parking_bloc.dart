// monitor_parkings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:bloc/bloc.dart';
import 'package:shared/shared.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingsBloc extends Bloc<ParkingsEvent, ParkingsState> {
  ParkingsBloc() : super(ParkingsInitial());

  @override
  Stream<ParkingsState> mapEventToState(ParkingsEvent event) async* {
    if (event is FetchParkingsEvent) {
      yield ParkingsLoading();
      try {
        final parkings = await ParkingRepository.instance.getAllParkings();
        yield ParkingsLoaded(parkings);
      } catch (e) {
        yield ParkingsError('Error loading parkings: $e');
      }
    } else if (event is AddParkingEvent) {
      try {
        await ParkingRepository.instance.createParking(event.newParking);
        yield ParkingsAddSuccess();
        add(FetchParkingsEvent());
      } catch (e) {
        yield ParkingsError('Error adding parking: $e');
      }
    } else if (event is EditParkingEvent) {
      try {
        await ParkingRepository.instance
            .updateParking(event.updatedParking.id, event.updatedParking);
        yield ParkingsEditSuccess();
        add(FetchParkingsEvent());
      } catch (e) {
        yield ParkingsError('Error editing parking: $e');
      }
    } else if (event is DeleteParkingEvent) {
      try {
        await ParkingRepository.instance.deleteParking(event.parkingId);
        yield ParkingsDeleteSuccess();
        add(FetchParkingsEvent());
      } catch (e) {
        yield ParkingsError('Error deleting parking: $e');
      }
    }
  }
}
