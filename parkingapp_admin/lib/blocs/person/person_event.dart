// part of 'person_bloc.dart';

// abstract class PersonEvent {}

// class FetchPersonsEvent extends PersonEvent {}

// class AddPersonEvent extends PersonEvent {
//   final Person person;
//   AddPersonEvent(this.person);
// }

// class UpdatePersonEvent extends PersonEvent {
//   final Person person;
//   UpdatePersonEvent(this.person);
// }

// class DeletePersonEvent extends PersonEvent {
//   final int personId;
//   DeletePersonEvent(this.personId);
// }

part of 'person_bloc.dart';

/// Base class for all person-related events.
abstract class PersonEvent {
  const PersonEvent();
}

/// Event to fetch all persons.
class FetchPersonsEvent extends PersonEvent {
  const FetchPersonsEvent();
}

/// Event to add a new person.
class AddPersonEvent extends PersonEvent {
  final Person person;

  const AddPersonEvent(this.person);
}

/// Event to update an existing person.
class UpdatePersonEvent extends PersonEvent {
  final Person person;

  const UpdatePersonEvent(this.person);
}

/// Event to delete a person by their ID.
class DeletePersonEvent extends PersonEvent {
  final int personId;

  const DeletePersonEvent(this.personId);
}
