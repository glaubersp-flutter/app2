import 'dart:math';

import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/weather_repository.dart';

class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeatherByCityName(String cityName) {
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();

      return Weather(
          cityName: cityName,
          temperatureCelsius: 20 + random.nextInt(15) + random.nextDouble());
    });
  }

  @override
  Future<Weather> fetchWeatherByLocation() {
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();

      return Weather(
          cityName: "GhostTown",
          temperatureCelsius: 20 + random.nextInt(15) + random.nextDouble());
    });
  }
}
