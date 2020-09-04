import 'dart:convert';
import 'dart:math';

import 'package:app2/src/data/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRepository {
  static const String apiKey = '591a1ae80f87bdbdb20e16449734e891';
  static const String part = 'minutely,hourly,daily';

  Future<Weather> fetchWeatherByCityName(String cityName);

  Future<Weather> fetchWeatherByLocation();
}

class NetworkException implements Exception {}

class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeatherByCityName(String cityName) {
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();
      if (random.nextBool()) {
        throw NetworkException();
      }
      return Weather(
          cityName: cityName,
          temperatureCelsius: 20 + random.nextInt(15) + random.nextDouble());
    });
  }

  @override
  Future<Weather> fetchWeatherByLocation() {
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();
      if (random.nextBool()) {
        throw NetworkException();
      }
      return Weather(
          cityName: "GhostTown",
          temperatureCelsius: 20 + random.nextInt(15) + random.nextDouble());
    });
  }
}

class OpenWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeatherByCityName(String cityName) async {
    List<Location> locations = await locationFromAddress(cityName);
    if (locations.isEmpty) {
      throw NetworkException();
    }

    var location = locations.first;
    var response = await _queryRemoteTemperature(location.latitude,
        location.longitude, WeatherRepository.part, WeatherRepository.apiKey);

    if (response.statusCode != 200) {
      throw NetworkException();
    }
    return Weather.fromJson(cityName, json.decode(response.body));
  }

  @override
  Future<Weather> fetchWeatherByLocation() async {
    Position position = await _getCurrentLocation();
    if (position == null) {
      throw NetworkException();
    }

    Placemark addressFromPosition = await _getAddressFromPosition(position);

    var response = await _queryRemoteTemperature(position.latitude,
        position.longitude, WeatherRepository.part, WeatherRepository.apiKey);

    if (response.statusCode != 200) {
      throw NetworkException();
    }
    return Weather.fromJson(
        addressFromPosition.locality, json.decode(response.body));
  }

  Future<http.Response> _queryRemoteTemperature(
      double latitude, double longitude, String part, String apiKey) {
    return http.get('https://api.openweathermap.org/data/2.5/onecall?' +
        'lat=$latitude&lon=$longitude&units=metric' +
        '&exclude=$part&appid=$apiKey');
  }

  Future<Position> _getCurrentLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Placemark> _getAddressFromPosition(Position position) async {
    List<Placemark> p =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return p.first;
  }
}
