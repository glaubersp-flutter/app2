import 'package:app2/src/data/weather.dart';
import 'package:http/http.dart' as http;
// import 'weather_repository_stub.dart'
//     if (dart.library.io) 'open_weather_repository.dart'
//     if (dart.library.js) 'web_weather_repository.dart';
import 'web_weather_repository.dart';

abstract class WeatherRepository {
  static const String apiKey = '';
  static const String part = 'minutely,hourly,daily';

  factory WeatherRepository() => getWeatherRepository();

  Future<Weather> fetchWeatherByCityName(String cityName);

  Future<Weather> fetchWeatherByLocation();
}

class NetworkException implements Exception {}

Future<http.Response> queryRemoteTemperature(
    double latitude, double longitude, String part, String apiKey) {
  return http.get(Uri.https("api.openweathermap.org", "/data/2.5/onecall", {
    "lat": latitude.toString(),
    "lon": longitude.toString(),
    "units": "metric",
    "exclude": part,
    "appid": apiKey
  }));
}
