import 'package:app2/src/bloc/weather_bloc.dart';
import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockWeatherBlock extends MockBloc<Weather> implements WeatherBloc {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  group('Testing WeatherBlock object with mocked repository', () {
    WeatherRepository _weatherRepository;
    WeatherBloc weatherBlock;
    final weather = Weather(cityName: "Campinas", temperatureCelsius: 35);

    setUp(() {
      _weatherRepository = MockWeatherRepository();
      weatherBlock = WeatherBloc(_weatherRepository);
    });

    test('throws AssertionError if WeatherRepository is null', () {
      expect(
        () => WeatherBloc(null),
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
        act: (WeatherBloc bloc) =>
            bloc.add(GetWeatherEventByCityName("Campinas")),
        expect: [WeatherLoading(), WeatherLoaded(weather)]);

    blocTest('Emit correct states for a failed GetWeatherEventByCityName event',
        build: () {
          when(_weatherRepository.fetchWeatherByCityName("Campinas"))
              .thenThrow(NetworkException());
          return weatherBlock;
        },
        act: (WeatherBloc bloc) =>
            bloc.add(GetWeatherEventByCityName("Campinas")),
        expect: [WeatherLoading(), WeatherError("Error loading weather")]);

    blocTest(
        'Emit correct states for a successful GetWeatherEventByCurrentLocation event',
        build: () {
          when(_weatherRepository.fetchWeatherByLocation())
              .thenAnswer((_) => Future.value(weather));
          return weatherBlock;
        },
        act: (WeatherBloc bloc) => bloc.add(GetWeatherEventByCurrentLocation()),
        expect: [WeatherLoading(), WeatherLoaded(weather)]);

    blocTest(
        'Emit correct states for a failed GetWeatherEventByCurrentLocation event',
        build: () {
          when(_weatherRepository.fetchWeatherByLocation())
              .thenThrow(NetworkException());
          return weatherBlock;
        },
        act: (WeatherBloc bloc) => bloc.add(GetWeatherEventByCurrentLocation()),
        expect: [WeatherLoading(), WeatherError("Error loading weather")]);
    tearDown(() {
      weatherBlock.close();
    });
  });
}
