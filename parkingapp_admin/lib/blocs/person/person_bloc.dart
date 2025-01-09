// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:client_repositories/async_http_repos.dart';
// import 'package:bloc/bloc.dart';
// import 'package:shared/shared.dart';

// part 'person_event.dart';
// part 'person_state.dart';

// class PersonBloc extends Bloc<PersonEvent, PersonState> {
//   PersonBloc() : super(PersonInitialState());

//   @override
//   Stream<PersonState> mapEventToState(PersonEvent event) async* {
//     if (event is FetchPersonsEvent) {
//       yield PersonLoadingState();
//       try {
//         final persons = await PersonRepository.instance.getAllPersons();
//         yield PersonLoadedState(persons);
//       } catch (e) {
//         yield PersonErrorState("Error fetching data: $e");
//       }
//     } else if (event is AddPersonEvent) {
//       try {
//         await PersonRepository.instance.createPerson(event.person);
//         yield PersonAddedState();
//         add(FetchPersonsEvent()); // Refresh the list after adding
//       } catch (e) {
//         yield PersonErrorState("Error adding person: $e");
//       }
//     } else if (event is UpdatePersonEvent) {
//       try {
//         await PersonRepository.instance
//             .updatePerson(event.person.id, event.person);
//         yield PersonUpdatedState();
//         add(FetchPersonsEvent()); // Refresh the list after updating
//       } catch (e) {
//         yield PersonErrorState("Error updating person: $e");
//       }
//     } else if (event is DeletePersonEvent) {
//       try {
//         await PersonRepository.instance.deletePerson(event.personId);
//         yield PersonDeletedState();
//         add(FetchPersonsEvent()); // Refresh the list after deletion
//       } catch (e) {
//         yield PersonErrorState("Error deleting person: $e");
//       }
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:bloc/bloc.dart';
import 'package:shared/shared.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(const PersonInitialState()) {
    on<FetchPersonsEvent>(_onFetchPersons);
    on<AddPersonEvent>(_onAddPerson);
    on<UpdatePersonEvent>(_onUpdatePerson);
    on<DeletePersonEvent>(_onDeletePerson);
  }

  Future<void> _onFetchPersons(
      FetchPersonsEvent event, Emitter<PersonState> emit) async {
    emit(const PersonLoadingState());
    try {
      final persons = await PersonRepository.instance.getAllPersons();
      emit(PersonLoadedState(persons));
    } catch (e) {
      emit(PersonErrorState("Error fetching data: $e"));
    }
  }

  Future<void> _onAddPerson(
      AddPersonEvent event, Emitter<PersonState> emit) async {
    try {
      await PersonRepository.instance.createPerson(event.person);
      emit(const PersonAddedState());
      add(const FetchPersonsEvent());
    } catch (e) {
      emit(PersonErrorState("Error adding person: $e"));
    }
  }

  Future<void> _onUpdatePerson(
      UpdatePersonEvent event, Emitter<PersonState> emit) async {
    try {
      await PersonRepository.instance
          .updatePerson(event.person.id, event.person);
      emit(const PersonUpdatedState());
      add(const FetchPersonsEvent());
    } catch (e) {
      emit(PersonErrorState("Error updating person: $e"));
    }
  }

  Future<void> _onDeletePerson(
      DeletePersonEvent event, Emitter<PersonState> emit) async {
    try {
      await PersonRepository.instance.deletePerson(event.personId);
      emit(const PersonDeletedState());
      add(const FetchPersonsEvent());
    } catch (e) {
      emit(PersonErrorState("Error deleting person: $e"));
    }
  }
}
