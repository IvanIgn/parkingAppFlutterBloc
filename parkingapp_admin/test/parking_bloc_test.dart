import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:shared/shared.dart';
import 'package:parkingapp_admin/blocs/parking/parking_bloc.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

class FakeParking extends Fake implements Parking {}

void main() {
  late ParkingsBloc parkingsBloc;
  late MockParkingRepository mockParkingRepository;

  setUpAll(() {
    // Register the fallback value for Person
    registerFallbackValue(FakeParking());
  });

  setUp(() {
    mockParkingRepository = MockParkingRepository();
    parkingsBloc = ParkingsBloc(mockParkingRepository);
  });

  tearDown(() {
    parkingsBloc.close();
  });

  group('LoadParkingsEvent', () {


    final parkings = [
            Parking(
              id: 1,
              startTime: DateTime.now(),
              endTime: DateTime.now().add(const Duration(hours: 2)),
              parkingSpace: ParkingSpace(
                  id: 1, address: 'Testadress 10', pricePerHour: 100),
              vehicle: Vehicle(
                regNumber: 'ABC111',
                vehicleType: 'Bil',
                owner: Person(name: 'TestNamn1', personNumber: '199501071111'),
              ),
            ),
            Parking(
              id: 2,
              startTime: DateTime.now(),
              endTime: DateTime.now().add(const Duration(hours: 3)),
              parkingSpace: ParkingSpace(
                  id: 2, address: 'Testadress 20', pricePerHour: 200),
              vehicle: Vehicle(
                regNumber: 'ABC222',
                vehicleType: 'Lastbil',
                owner: Person(name: 'TestNamn2', personNumber: '199501072222'),
              ),
            ),
          ];

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'emits [MonitorParkingsLoadingState, MonitorParkingsLoadedState] on successful fetch',
      build: () {
        when(() => mockParkingRepository.getAllParkings()).thenAnswer(
          (_) async => parkings,
        );
        return parkingsBloc;
      },
      act: (bloc) async {
        bloc.add(LoadParkingsEvent());
      },
      expect: () => [
        MonitorParkingsLoadingState(),
        MonitorParkingsLoadedState(
          parkings),
      ],
      verify: (_) {
        verify(() => mockParkingRepository.getAllParkings()).called(1);
      },
    );

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'emits [MonitorParkingsLoadingState, MonitorParkingsErrorState] on fetch failure',
      build: () {
        when(() => mockParkingRepository.getAllParkings())
            .thenThrow(Exception('Failed to fetch parkings'));
        return parkingsBloc;
      },
      act: (bloc) => bloc.add(LoadParkingsEvent()),
      expect: () => [
        MonitorParkingsLoadingState(),
        MonitorParkingsErrorState(
            errorMessage: 'Exception: Failed to fetch parkings'),
      ],
      verify: (_) {
        verify(() => mockParkingRepository.getAllParkings()).called(1);
      },
    );
  });

  group('AddParkingEvent', () {
    final parking = Parking(
      id: 1,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      parkingSpace:
          ParkingSpace(id: 1, address: 'Testadress 10', pricePerHour: 100),
      vehicle: Vehicle(
          regNumber: 'ABC111',
          vehicleType: 'Bil',
          owner: Person(name: 'TestNamn1', personNumber: '199501071111')),
    );

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'triggers LoadParkingsEvent on successful add',
      build: () {
        when(() => mockParkingRepository.createParking(parking))
            .thenAnswer((_) async => parking);
        when(() => mockParkingRepository.getAllParkings())
            .thenAnswer((_) async => [parking]);
        return parkingsBloc;
      },
      act: (bloc) => bloc.add(AddParkingEvent(parking)),
      expect: () => [
        // bloc will emit first loading then loaded after an add is performed
        isA<MonitorParkingsLoadingState>(),
        isA<MonitorParkingsLoadedState>()

      ],
      verify: (_) {
        verify(() => mockParkingRepository.createParking(parking)).called(1);
        verify(() => mockParkingRepository.getAllParkings()).called(1);
      },
    );

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'emits MonitorParkingsErrorState on add failure',
      build: () {
        when(() => mockParkingRepository.createParking(parking))
            .thenThrow(Exception('Failed to add parking'));
        return parkingsBloc;
      },
      act: (bloc) => bloc.add(AddParkingEvent(parking)),
      expect: () => [
        MonitorParkingsErrorState(
            errorMessage: 'Exception: Failed to add parking'),
      ],
      verify: (_) {
        verify(() => mockParkingRepository.createParking(parking)).called(1);
      },
    );
  });

  group('EditParkingEvent', () {
    final parking = Parking(
      id: 1,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      parkingSpace:
          ParkingSpace(id: 1, address: 'Testadress 10', pricePerHour: 100),
      vehicle: Vehicle(
          regNumber: 'ABC111',
          vehicleType: 'Bil',
          owner: Person(name: 'TestNamn1', personNumber: '199501071111')),
    );

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'triggers LoadParkingsEvent on successful edit',
      build: () {
        when(() => mockParkingRepository.updateParking(parking.id, parking))
            .thenAnswer((_) async => parking);
        when(() => mockParkingRepository.getAllParkings())
            .thenAnswer((_) async => [parking]);
        return parkingsBloc;
      },
      act: (bloc) =>
          bloc.add(EditParkingEvent(parkingId: parking.id, parking: parking)),
      expect: () => [

        isA<MonitorParkingsLoadingState>(),
        isA<MonitorParkingsLoadedState>()

      ],
      verify: (_) {
        verify(() => mockParkingRepository.updateParking(parking.id, parking))
            .called(1);
        verify(() => mockParkingRepository.getAllParkings()).called(1);
      },
    );

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'emits MonitorParkingsErrorState on edit failure',
      build: () {
        when(() => mockParkingRepository.updateParking(parking.id, parking))
            .thenThrow(Exception('Failed to edit parking'));
        return parkingsBloc;
      },
      act: (bloc) =>
          bloc.add(EditParkingEvent(parkingId: parking.id, parking: parking)),
      expect: () => [
        MonitorParkingsErrorState(
            errorMessage: 'Exception: Failed to edit parking'),
      ],
      verify: (_) {
        verify(() => mockParkingRepository.updateParking(parking.id, parking))
            .called(1);
      },
    );
  });

  group('DeleteParkingEvent', () {
    const parkingId = 1;

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'triggers LoadParkingsEvent on successful delete',
      build: () {
        when(() => mockParkingRepository.deleteParking(parkingId))
            .thenAnswer((_) async => Future.value(FakeParking()));
        when(() => mockParkingRepository.getAllParkings())
            .thenAnswer((_) async => []);
        return parkingsBloc;
      },
      act: (bloc) => bloc.add(DeleteParkingEvent(parkingId)),
      expect: () => [

        isA<MonitorParkingsLoadingState>(),
        isA<MonitorParkingsLoadedState>()

      ],
      verify: (_) {
        verify(() => mockParkingRepository.deleteParking(parkingId)).called(1);
        verify(() => mockParkingRepository.getAllParkings()).called(1);
      },
    );

    blocTest<ParkingsBloc, MonitorParkingsState>(
      'emits MonitorParkingsErrorState on delete failure',
      build: () {
        when(() => mockParkingRepository.deleteParking(parkingId))
            .thenThrow(Exception('Failed to delete parking'));
        return parkingsBloc;
      },
      act: (bloc) => bloc.add(DeleteParkingEvent(parkingId)),
      expect: () => [
        MonitorParkingsErrorState(
            errorMessage: 'Exception: Failed to delete parking'),
      ],
      verify: (_) {
        verify(() => mockParkingRepository.deleteParking(parkingId)).called(1);
      },
    );
  });
}
