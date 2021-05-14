part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeatherEventByCityName extends WeatherEvent {
  final String cityName;

  const GetWeatherEventByCityName(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class GetWeatherEventByCurrentLocation extends WeatherEvent {
  const GetWeatherEventByCurrentLocation();

  @override
  List<Object> get props => [];
}
