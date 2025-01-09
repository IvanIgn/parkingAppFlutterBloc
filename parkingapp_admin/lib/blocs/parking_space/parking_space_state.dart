// parking_spaces_state.dart

//import 'package:equatable/equatable.dart';

part of 'parking_space_bloc.dart';

abstract class ParkingSpacesState {
  @override
  List<Object> get props => [];
}

class ParkingSpacesInitial extends ParkingSpacesState {}

class ParkingSpacesLoading extends ParkingSpacesState {}

class ParkingSpacesLoaded extends ParkingSpacesState {
  final List<ParkingSpace> parkingSpaces;

  ParkingSpacesLoaded(this.parkingSpaces);

  @override
  List<Object> get props => [parkingSpaces];
}

class ParkingSpacesError extends ParkingSpacesState {
  final String errorMessage;

  ParkingSpacesError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
