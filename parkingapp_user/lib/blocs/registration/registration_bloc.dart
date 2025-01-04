import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart'; // PersonRepository

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final PersonRepository _personRepository = PersonRepository.instance;

  RegistrationBloc() : super(RegistrationInitial()) {
    // Registering the handler for RegistrationSubmitted event
    on<RegistrationSubmitted>((event, emit) async {
      await _mapRegistrationSubmittedToState(event, emit);
    });
  }

  Future<void> _mapRegistrationSubmittedToState(
      RegistrationSubmitted event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());

    try {
      // Basic form validation
      if (event.name.isEmpty || event.personNum.length < 12) {
        emit(RegistrationError(errorMessage: "Invalid form data"));
        return;
      }

      // Check if the person already exists
      final personList = await _personRepository.getAllPersons();
      final personMap = {
        for (var person in personList) person.personNumber: person
      };

      if (personMap.containsKey(event.personNum)) {
        emit(RegistrationError(
            errorMessage:
                'Personen med detta personnummer ${event.personNum} är redan registrerad'));
        return;
      }

      // Create new person
      final newPerson = Person(
        id: 0,
        name: event.name,
        personNumber: event.personNum,
      );

      await _personRepository.createPerson(newPerson);

      emit(RegistrationSuccess(successMessage: "Registration successful!"));
    } catch (e) {
      emit(RegistrationError(errorMessage: "Error during registration: $e"));
    }
  }
}
