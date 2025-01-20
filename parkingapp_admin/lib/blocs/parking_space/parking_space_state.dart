part of 'parking_space_bloc.dart';

// abstract class ParkingSpaceState extends Equatable {
//   const ParkingSpaceState();

//   @override
//   List<Object?> get props => [];
// }

// class ParkingSpaceLoading extends ParkingSpaceState {}

// class ParkingSpaceLoaded extends ParkingSpaceState {
//   final List<ParkingSpace> parkingSpaces;

//   const ParkingSpaceLoaded({required this.parkingSpaces});

//   @override
//   List<Object?> get props => [parkingSpaces];
// }

// class ParkingSpaceError extends ParkingSpaceState {
//   final String message;

//   const ParkingSpaceError({required this.message});

//   @override
//   List<Object?> get props => [message];
// }

// class ParkingSpaceActionSuccess extends ParkingSpaceState {
//   final String message;

//   const ParkingSpaceActionSuccess({required this.message});

//   @override
//   List<Object?> get props => [message];
// }

abstract class ParkingSpaceState extends Equatable {
  const ParkingSpaceState();

  @override
  List<Object?> get props => [];
}

class ParkingSpaceInitial extends ParkingSpaceState {}

class ParkingSpaceLoading extends ParkingSpaceState {}

class ParkingSpaceLoaded extends ParkingSpaceState {
  final List<ParkingSpace> parkingSpaces;

  const ParkingSpaceLoaded(this.parkingSpaces);

  @override
  List<Object?> get props => [parkingSpaces];
}

class ParkingSpaceError extends ParkingSpaceState {
  final String message;

  const ParkingSpaceError(this.message);

  @override
  List<Object?> get props => [message];
}
