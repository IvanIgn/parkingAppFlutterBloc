// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:shared/shared.dart';
// import 'package:equatable/equatable.dart';

// part 'person_event.dart';
// part 'person_state.dart';

// class PersonBloc extends Bloc<PersonEvent, PersonState> {
//   final PersonRepository repository;

//   PersonBloc({required this.repository}) : super(PersonInitialState()) {
//     on<FetchPersonsEvent>(_onFetchPersons);
//     on<AddPersonEvent>(_onAddPerson);
//     on<UpdatePersonEvent>(_onUpdatePerson);
//     on<DeletePersonEvent>(_onDeletePerson);
//   }

//   // Future<void> _onFetchPersons(
//   //     FetchPersonsEvent event, Emitter<PersonState> emit) async {
//   //   emit(PersonLoadingState());
//   //   try {
//   //     final persons = await repository.getAllPersons();
//   //     emit(PersonLoadedState(persons));
//   //   } catch (e) {
//   //     emit(PersonErrorState("Error fetching persons: $e"));
//   //   }
//   // }

//   // Future<void> _onAddPerson(
//   //     AddPersonEvent event, Emitter<PersonState> emit) async {
//   //   emit(PersonLoadingState()); // Emit loading state once
//   //   try {
//   //     final person =
//   //         await repository.createPerson(event.person); // Create the person
//   //     emit(PersonAddedState(person)); // Emit added state

//   //     // Fetch the updated list of persons, but avoid emitting another loading state
//   //     final persons = await repository.getAllPersons();
//   //     emit(PersonLoadedState(persons)); // Emit the updated list of persons
//   //   } catch (e) {
//   //     emit(PersonErrorState("Error adding person: $e"));
//   //   }
//   // }

//   Future<void> _onFetchPersons(
//       FetchPersonsEvent event, Emitter<PersonState> emit) async {
//     emit(PersonLoadingState());
//     try {
//       final persons = await repository.getAllPersons();
//       emit(PersonLoadedState(persons));
//     } catch (e) {
//       emit(PersonErrorState("Error fetching persons: $e"));
//     }
//   }

//   Future<void> _onAddPerson(
//       AddPersonEvent event, Emitter<PersonState> emit) async {
//     try {
//       final person = await repository.createPerson(event.person);
//       emit(PersonAddedState(person)); // Emit added state with new person

//       if (state is PersonLoadedState) {
//         final updatedList =
//             List<Person>.from((state as PersonLoadedState).persons)
//               ..add(person);
//         emit(PersonLoadedState(updatedList));
//       }
//     } catch (e) {
//       emit(PersonErrorState("Error adding person: $e"));
//     }
//   }

//   Future<void> _onUpdatePerson(
//       UpdatePersonEvent event, Emitter<PersonState> emit) async {
//     emit(PersonLoadingState()); // Emit loading state first
//     try {
//       await repository.updatePerson(
//           event.person.id, event.person); // Update the person
//       emit(PersonUpdatedState(event.person)); // Emit updated state

//       // Now, fetch the updated list of persons, but do not emit loading state again
//       final persons = await repository.getAllPersons();
//       emit(PersonLoadedState(persons)); // Emit updated list
//     } catch (e) {
//       emit(PersonErrorState("Error updating person: $e"));
//     }
//   }

//   Future<void> _onDeletePerson(
//       DeletePersonEvent event, Emitter<PersonState> emit) async {
//     emit(PersonLoadingState()); // Emit loading state first
//     try {
//       await repository.deletePerson(event.personId);
//       emit(PersonDeletedState(
//           event.personId)); // Emit deleted state after deletion
//       // Optionally fetch the updated list of persons
//       final persons = await repository.getAllPersons();
//       emit(PersonLoadedState(persons)); // Emit loaded state with updated list
//     } catch (e) {
//       emit(PersonErrorState(
//           "Error deleting person: $e")); // Emit error state if something goes wrong
//     }
//   }
// }

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:shared/shared.dart';
// import 'package:equatable/equatable.dart';

// part 'person_event.dart';
// part 'person_state.dart';

// class PersonBloc extends Bloc<PersonEvent, PersonState> {
//   final PersonRepository repository;

//   PersonBloc({required this.repository}) : super(PersonInitialState()) {
//     on<FetchPersonsEvent>(_onFetchPersons);
//     on<AddPersonEvent>(_onAddPerson);
//     on<UpdatePersonEvent>(_onUpdatePerson);
//     on<DeletePersonEvent>(_onDeletePerson);
//   }

//   Future<void> _onFetchPersons(
//       FetchPersonsEvent event, Emitter<PersonState> emit) async {
//     emit(PersonLoadingState());
//     try {
//       final persons = await repository.getAllPersons();
//       emit(PersonLoadedState(persons));
//     } catch (e) {
//       emit(PersonErrorState("Error fetching persons: $e"));
//     }
//   }

//   Future<void> _onAddPerson(
//       AddPersonEvent event, Emitter<PersonState> emit) async {
//     try {
//       final person = await repository.createPerson(event.person);
//       emit(PersonAddedState(person)); // Emit added state with new person

//       // Instead of refetching, update state manually
//       if (state is PersonLoadedState) {
//         final updatedList =
//             List<Person>.from((state as PersonLoadedState).persons)
//               ..add(person);
//         emit(PersonLoadedState(updatedList));
//       }
//     } catch (e) {
//       emit(PersonErrorState("Error adding person: $e"));
//     }
//   }

//   Future<void> _onUpdatePerson(
//       UpdatePersonEvent event, Emitter<PersonState> emit) async {
//     try {
//       await repository.updatePerson(event.person.id, event.person);
//       emit(PersonUpdatedState(event.person)); // Emit updated state with person

//       if (state is PersonLoadedState) {
//         final updatedList = (state as PersonLoadedState)
//             .persons
//             .map((p) => p.id == event.person.id ? event.person : p)
//             .toList();
//         emit(PersonLoadedState(updatedList));
//       }
//     } catch (e) {
//       emit(PersonErrorState("Error updating person: $e"));
//     }
//   }

//   Future<void> _onDeletePerson(
//       DeletePersonEvent event, Emitter<PersonState> emit) async {
//     try {
//       await repository.deletePerson(event.personId);
//       emit(PersonDeletedState(event.personId)); // Emit deleted state with ID

//       if (state is PersonLoadedState) {
//         final updatedList = (state as PersonLoadedState)
//             .persons
//             .where((p) => p.id != event.personId)
//             .toList();
//         emit(PersonLoadedState(updatedList));
//       }
//     } catch (e) {
//       emit(PersonErrorState("Error deleting person: $e"));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';
import 'package:equatable/equatable.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;

  PersonBloc({required this.repository}) : super(PersonInitialState()) {
    on<FetchPersonsEvent>(_onFetchPersons);
    on<AddPersonEvent>(_onAddPerson);
    on<UpdatePersonEvent>(_onUpdatePerson);
    on<DeletePersonEvent>(_onDeletePerson);
  }

  Future<void> _onFetchPersons(
      FetchPersonsEvent event, Emitter<PersonState> emit) async {
    emit(PersonLoadingState());
    try {
      final persons = await repository.getAllPersons();
      emit(PersonLoadedState(persons)); // Ensure the updated list is emitted
    } catch (e) {
      emit(PersonErrorState("Error fetching persons: $e"));
    }
  }

  Future<void> _onAddPerson(
      AddPersonEvent event, Emitter<PersonState> emit) async {
    try {
      final newPerson = await repository.createPerson(event.person);

      if (state is PersonLoadedState) {
        final currentState = state as PersonLoadedState;
        final updatedList = List<Person>.from(currentState.persons)
          ..add(newPerson);
        emit(PersonLoadedState(updatedList));
      } else {
        emit(PersonLoadedState(
            [newPerson])); // Handle case where state is not loaded
      }
    } catch (e) {
      emit(PersonErrorState("Error adding person: $e"));
    }
  }

  Future<void> _onUpdatePerson(
      UpdatePersonEvent event, Emitter<PersonState> emit) async {
    try {
      await repository.updatePerson(event.person.id, event.person);

      if (state is PersonLoadedState) {
        final currentState = state as PersonLoadedState;
        final updatedList = currentState.persons.map((p) {
          return p.id == event.person.id ? event.person : p;
        }).toList();
        emit(PersonLoadedState(updatedList));
      }
    } catch (e) {
      emit(PersonErrorState("Error updating person: $e"));
    }
  }

  Future<void> _onDeletePerson(
      DeletePersonEvent event, Emitter<PersonState> emit) async {
    try {
      await repository.deletePerson(event.personId);

      if (state is PersonLoadedState) {
        final currentState = state as PersonLoadedState;
        final updatedList =
            currentState.persons.where((p) => p.id != event.personId).toList();
        emit(PersonLoadedState(updatedList));
      }
    } catch (e) {
      emit(PersonErrorState("Error deleting person: $e"));
    }
  }
}
