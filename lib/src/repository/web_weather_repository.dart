import 'dart:convert';

import 'package:app2/src/data/weather.dart';
import 'package:app2/src/js/geolocation.dart' as js;
import 'package:app2/src/js/js_geolocation/geolocation_cubit.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:js/js.dart';

class WebRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeatherByCityName(String cityName) {
    // TODO: implement fetchWeatherByCityName
    throw UnimplementedError();
  }

  @override
  Future<Weather> fetchWeatherByLocation() async {
    Weather weather;
    final geoCubit = GeolocationCubit();
    var listen = geoCubit.listen((GeolocationState state) async {
      switch (state.runtimeType) {
        case GeolocationLoaded:
          var geolocationLoaded = state as GeolocationLoaded;

          // Placemark addressFromPosition = await _getAddressFromPosition(position);

          var response = await queryRemoteTemperature(
              geolocationLoaded.latitude,
              geolocationLoaded.longitude,
              WeatherRepository.part,
              WeatherRepository.apiKey);

          if (response.statusCode != 200) {
            throw NetworkException();
          }
          weather = Weather.fromJson("", json.decode(response.body));
          return weather;
          break;
      }
    });
    js.getCurrentPosition(allowInterop((pos) {
      var _latitude;
      var _longitude;
      _latitude = pos.coords.latitude;
      _longitude = pos.coords.longitude;
      geoCubit.setPosition(_latitude, _longitude);
      return;
    }));
    await listen.asFuture(weather);
    listen.cancel();
    return Future.value(weather);
  }
}
