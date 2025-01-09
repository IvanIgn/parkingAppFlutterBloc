// parking_spaces_event.dart

part of 'parking_space_bloc.dart';

abstract class ParkingSpacesEvent {
  List<Object> get props => [];
}

class LoadParkingSpaces extends ParkingSpacesEvent {}

class AddParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;

  AddParkingSpace({required this.parkingSpace});
  @override
  List<Object> get props => [parkingSpace];
}

class EditParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;

  EditParkingSpace({required this.parkingSpace});
  @override
  List<Object> get props => [parkingSpace];
}

class DeleteParkingSpace extends ParkingSpacesEvent {
  final int id;

  DeleteParkingSpace({required this.id});
  @override
  List<Object> get props => [id];
}
