import 'package:app2/src/data/weather.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRepository {
  static const String apiKey = '591a1ae80f87bdbdb20e16449734e891';
  static const String part = 'minutely,hourly,daily';

  Future<Weather> fetchWeatherByCityName(String cityName);

  Future<Weather> fetchWeatherByLocation();
}

class NetworkException implements Exception {}

Future<http.Response> queryRemoteTemperature(
    double latitude, double longitude, String part, String apiKey) {
  return http.get('https://api.openweathermap.org/data/2.5/onecall?' +
      'lat=$latitude&lon=$longitude&units=metric' +
      '&exclude=$part&appid=$apiKey');
}
