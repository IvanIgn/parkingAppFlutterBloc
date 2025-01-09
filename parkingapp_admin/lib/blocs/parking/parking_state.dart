part of 'parking_bloc.dart';

abstract class ParkingsState {}

class ParkingsInitial extends ParkingsState {}

class ParkingsLoading extends ParkingsState {}

class ParkingsLoaded extends ParkingsState {
  final List<Parking> parkings;
  ParkingsLoaded(this.parkings);
}

class ParkingsError extends ParkingsState {
  final String message;
  ParkingsError(this.message);
}

class ParkingsAddSuccess extends ParkingsState {}

class ParkingsEditSuccess extends ParkingsState {}

class ParkingsDeleteSuccess extends ParkingsState {}

class OverviewStatisticsInitial extends ParkingsState {}

class OverviewStatisticsLoading extends ParkingsState {}

class OverviewStatisticsLoaded extends ParkingsState {
  final List<Parking> parkings;
  final Map<String, dynamic> statistics;

  OverviewStatisticsLoaded(this.parkings, this.statistics);
}

class OverviewStatisticsError extends ParkingsState {
  final String message;

  OverviewStatisticsError(this.message);
}
