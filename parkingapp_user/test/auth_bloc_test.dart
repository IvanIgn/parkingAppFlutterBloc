import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkingapp_user/blocs/auth/auth_bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockPersonRepository extends Mock implements PersonRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthBloc authBloc;
  late MockPersonRepository mockPersonRepository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockPersonRepository = MockPersonRepository();
    authBloc = AuthBloc(personRepository: mockPersonRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(() => mockPersonRepository.getAllPersons()).thenAnswer(
          (_) async => [
            Person(name: 'Test User', personNumber: '12345'),
          ],
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested(personName: 'Test User', personNum: '12345'),
      ),
      expect: () => [
        AuthLoading(),
        const AuthAuthenticated(name: 'Test User', personNumber: '12345'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails due to unregistered user',
      build: () {
        when(() => mockPersonRepository.getAllPersons()).thenAnswer(
          (_) async => [
            Person(name: 'Test User', personNumber: '12345'),
          ],
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested(personName: 'Wrong User', personNum: '67890'),
      ),
      expect: () => [
        AuthLoading(),
        isA<AuthError>(),
      ],
      verify: (bloc) {
        final errorState = bloc.state as AuthError;
        expect(errorState.errorMessage, contains('är inte registrerad'));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthLoggedOut] on logout',
      build: () => authBloc,
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [
        AuthLoading(),
        AuthLoggedOut(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] if user is already authenticated',
      build: () {
        when(() => SharedPreferences.getInstance()).thenAnswer((_) async {
          final instance = MockSharedPreferences();
          when(() => instance.getString('loggedInName'))
              .thenReturn('Test User');
          when(() => instance.getString('loggedInPersonNum'))
              .thenReturn('12345');
          return instance;
        });
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        AuthLoading(),
        const AuthAuthenticated(name: 'Test User', personNumber: '12345'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthLoggedOut] if no user is authenticated',
      build: () {
        when(() => SharedPreferences.getInstance()).thenAnswer((_) async {
          final instance = MockSharedPreferences();
          when(() => instance.getString('loggedInName')).thenReturn(null);
          when(() => instance.getString('loggedInPersonNum')).thenReturn(null);
          return instance;
        });
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        AuthLoading(),
        AuthLoggedOut(),
      ],
    );
  });
}
