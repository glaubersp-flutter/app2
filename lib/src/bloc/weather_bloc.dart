import 'dart:async';

import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository)
      : assert(_weatherRepository != null),
        super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    switch (event.runtimeType) {
      case GetWeatherEventByCityName:
        try {
          yield WeatherLoading();
          final weather = await _weatherRepository.fetchWeatherByCityName(
              (event as GetWeatherEventByCityName).cityName);
          yield WeatherLoaded(weather);
        } on NetworkException {
          yield WeatherError("Error loading weather");
        }
        break;
      case GetWeatherEventByCurrentLocation:
        try {
          yield WeatherLoading();
          final weather = await _weatherRepository.fetchWeatherByLocation();
          yield WeatherLoaded(weather);
        } on NetworkException {
          yield WeatherError("Error loading weather");
        }
        break;
      default:
        yield WeatherInitial();
    }
  }
}
