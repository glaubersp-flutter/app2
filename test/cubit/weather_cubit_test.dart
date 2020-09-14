import 'package:app2/src/cubit/weather_cubit.dart';
import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockWeatherBlock extends MockBloc<Weather> implements WeatherCubit {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  group('Testing WeatherBlock object with mocked repository', () {
    WeatherRepository _weatherRepository;
    WeatherCubit weatherBlock;
    final weather = Weather(cityName: "Campinas", temperatureCelsius: 35);

    setUp(() {
      _weatherRepository = MockWeatherRepository();
      weatherBlock = WeatherCubit(_weatherRepository);
    });

    test('throws AssertionError if WeatherRepository is null', () {
      expect(
        () => WeatherCubit(null),
        throwsA(isAssertionError),
      );
    });

    test('Initial state', () {
      expect(weatherBlock.state, WeatherInitial());
    });

    blocTest(
        'Emit correct states for a successful GetWeatherEventByCityName event',
        build: () {
          when(_weatherRepository.fetchWeatherByCityName("Campinas"))
              .thenAnswer((_) => Future.value(weather));
          return weatherBlock;
        },
        act: (WeatherCubit bloc) => bloc.getWeatherByCity("Campinas"),
        expect: [WeatherLoading(), WeatherLoaded(weather)]);

    blocTest('Emit correct states for a failed GetWeatherEventByCityName event',
        build: () {
          when(_weatherRepository.fetchWeatherByCityName("Campinas"))
              .thenThrow(NetworkException());
          return weatherBlock;
        },
        act: (WeatherCubit bloc) => bloc.getWeatherByCity("Campinas"),
        expect: [WeatherLoading(), WeatherError("Error fetching weather!")]);

    blocTest(
        'Emit correct states for a successful GetWeatherEventByCurrentLocation event',
        build: () {
          when(_weatherRepository.fetchWeatherByLocation())
              .thenAnswer((_) => Future.value(weather));
          return weatherBlock;
        },
        act: (WeatherCubit bloc) => bloc.getWeatherByLocation(),
        expect: [WeatherLoading(), WeatherLoaded(weather)]);

    blocTest(
        'Emit correct states for a failed GetWeatherEventByCurrentLocation event',
        build: () {
          when(_weatherRepository.fetchWeatherByLocation())
              .thenThrow(NetworkException());
          return weatherBlock;
        },
        act: (WeatherCubit bloc) => bloc.getWeatherByLocation(),
        expect: [WeatherLoading(), WeatherError("Error fetching weather!")]);
    tearDown(() {
      weatherBlock.close();
    });
  });
}
