part of 'parking_bloc.dart';

abstract class MonitorParkingsState {}

class MonitorParkingsInitialState extends MonitorParkingsState {}

class MonitorParkingsLoadingState extends MonitorParkingsState {}

class MonitorParkingsLoadedState extends MonitorParkingsState {
  final List<Parking> parkings;

  MonitorParkingsLoadedState(this.parkings);
}

class MonitorParkingsErrorState extends MonitorParkingsState {
  final String errorMessage;

  MonitorParkingsErrorState({required this.errorMessage});
}
