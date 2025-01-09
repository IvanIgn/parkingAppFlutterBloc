// vehicle_state.dart
part of 'vehicle_bloc.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object> get props => [];
}

class VehicleInitialState extends VehicleState {}

class VehicleLoadingState extends VehicleState {}

class VehicleLoadedState extends VehicleState {
  final List<Vehicle> vehicles;

  const VehicleLoadedState(this.vehicles);

  @override
  List<Object> get props => [vehicles];
}

class VehicleErrorState extends VehicleState {
  final String message;

  const VehicleErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class VehicleAddedState extends VehicleState {}

class VehicleUpdatedState extends VehicleState {}

class VehicleDeletedState extends VehicleState {}
