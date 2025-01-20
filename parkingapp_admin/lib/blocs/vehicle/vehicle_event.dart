// vehicle_event.dart
part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehicles extends VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;

  const AddVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class UpdateVehicle extends VehicleEvent {
  final Vehicle vehicle;

  const UpdateVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class DeleteVehicle extends VehicleEvent {
  final int vehicleId;

  const DeleteVehicle(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}
