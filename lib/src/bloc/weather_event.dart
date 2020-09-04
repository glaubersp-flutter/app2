part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class GetWeatherEventByCityName extends WeatherEvent {
  final String cityName;

  GetWeatherEventByCityName(this.cityName);
}

class GetWeatherEventByCurrentLocation extends WeatherEvent {
  GetWeatherEventByCurrentLocation();
}
