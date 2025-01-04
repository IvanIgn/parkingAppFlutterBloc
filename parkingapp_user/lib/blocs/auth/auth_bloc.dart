import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client_repositories/async_http_repos.dart'; // Assume this contains PersonRepository and Person model

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PersonRepository personRepository;

  AuthBloc({required this.personRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus); // Add CheckAuthStatus handler
  }

  // Check Authentication Status
  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final loggedInName = prefs.getString('loggedInName');
      final loggedInPersonNum = prefs.getString('loggedInPersonNum');

      if (loggedInName != null && loggedInPersonNum != null) {
        emit(AuthAuthenticated(
            name: loggedInName, personNumber: loggedInPersonNum));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthError(errorMessage: 'Error checking authentication status: $e'));
    }
  }

  // Handle Login Request
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final persons = await personRepository.getAllPersons();
      final personMap = {for (var p in persons) p.personNumber: p};

      if (!personMap.containsKey(event.personNum) ||
          personMap[event.personNum]?.name != event.personName) {
        emit(AuthError(
            errorMessage:
                'Personen "${event.personName}" med personnummer "${event.personNum}" är inte registrerad.'));
        return;
      } else {
        // Save the logged-in user's data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInName', event.personName);
        await prefs.setString('loggedInPersonNum', event.personNum);

        // Emit AuthLoggedIn instead of AuthAuthenticated for clarity
        emit(AuthLoggedIn(
            name: event.personName, personNumber: event.personNum));
      }
    } catch (e) {
      emit(AuthError(errorMessage: 'An error occurred: $e'));
    }
  }

  // Handle Logout Request
  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('loggedInName');
      await prefs.remove('loggedInPersonNum');
      //await prefs.clear();

      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(errorMessage: 'An error occurred during logout: $e'));
    }
  }
}
