// part of 'person_bloc.dart';

// abstract class PersonState {}

// class PersonInitialState extends PersonState {}

// class PersonLoadingState extends PersonState {}

// class PersonLoadedState extends PersonState {
//   final List<Person> persons;
//   PersonLoadedState(this.persons);
// }

// class PersonErrorState extends PersonState {
//   final String message;
//   PersonErrorState(this.message);
// }

// class PersonAddedState extends PersonState {}

// class PersonUpdatedState extends PersonState {}

// class PersonDeletedState extends PersonState {}

part of 'person_bloc.dart';

/// Base class for all person-related states.
abstract class PersonState {
  const PersonState();
}

/// Initial state when the bloc is first created.
class PersonInitialState extends PersonState {
  const PersonInitialState();
}

/// State indicating a loading process.
class PersonLoadingState extends PersonState {
  const PersonLoadingState();
}

/// State when the list of persons is successfully loaded.
class PersonLoadedState extends PersonState {
  final List<Person> persons;

  const PersonLoadedState(this.persons);
}

/// State indicating an error occurred.
class PersonErrorState extends PersonState {
  final String message;

  const PersonErrorState(this.message);
}

/// State after successfully adding a person.
class PersonAddedState extends PersonState {
  const PersonAddedState();
}

/// State after successfully updating a person.
class PersonUpdatedState extends PersonState {
  const PersonUpdatedState();
}

/// State after successfully deleting a person.
class PersonDeletedState extends PersonState {
  const PersonDeletedState();
}
