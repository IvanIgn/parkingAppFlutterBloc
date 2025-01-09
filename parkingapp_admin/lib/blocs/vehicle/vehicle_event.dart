// vehicle_event.dart
part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class FetchVehiclesEvent extends VehicleEvent {}

class AddVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;

  const AddVehicleEvent(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class UpdateVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;

  const UpdateVehicleEvent(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class DeleteVehicleEvent extends VehicleEvent {
  final String vehicleId;

  const DeleteVehicleEvent(this.vehicleId);

  @override
  List<Object> get props => [vehicleId];
}
