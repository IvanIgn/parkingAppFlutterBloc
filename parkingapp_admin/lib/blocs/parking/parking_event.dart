part of 'parking_bloc.dart';

abstract class ParkingsEvent {}

class FetchParkingsEvent extends ParkingsEvent {}

class AddParkingEvent extends ParkingsEvent {
  final Parking newParking;
  AddParkingEvent(this.newParking);
}

class EditParkingEvent extends ParkingsEvent {
  final Parking updatedParking;
  EditParkingEvent(this.updatedParking);
}

class DeleteParkingEvent extends ParkingsEvent {
  final int parkingId;
  DeleteParkingEvent(this.parkingId);
}

class LoadParkingsEvent extends ParkingsEvent {}

class RefreshParkingsEvent extends ParkingsEvent {}
