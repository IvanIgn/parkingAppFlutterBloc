part of 'parking_space_bloc.dart';

abstract class ParkingSpaceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingSpaceInitial extends ParkingSpaceState {}

class ParkingSpaceLoading extends ParkingSpaceState {}

class ParkingSpaceLoaded extends ParkingSpaceState {
  final List<ParkingSpace> parkingSpaces;

  ParkingSpaceLoaded(this.parkingSpaces);

  @override
  List<Object?> get props => [parkingSpaces];
}

class ParkingSpaceError extends ParkingSpaceState {
  final String errorMessage;

  ParkingSpaceError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
