part of 'parking_space_bloc.dart';

abstract class ParkingSpaceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadParkingSpaces extends ParkingSpaceEvent {}

class AddParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace parkingSpace;

  AddParkingSpace(this.parkingSpace);

  @override
  List<Object?> get props => [parkingSpace];
}

class UpdateParkingSpace extends ParkingSpaceEvent {
  final int id;
  final ParkingSpace updatedParkingSpace;

  UpdateParkingSpace(this.id, this.updatedParkingSpace);

  @override
  List<Object?> get props => [id, updatedParkingSpace];
}

class DeleteParkingSpace extends ParkingSpaceEvent {
  final int id;

  DeleteParkingSpace(this.id);

  @override
  List<Object?> get props => [id];
}
