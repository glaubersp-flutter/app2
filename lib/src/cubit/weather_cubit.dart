import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherCubit(this._weatherRepository) : super(WeatherInitial());

  Future<void> getWeatherByCity(String cityName) async {
    try {
      emit(WeatherLoading());
      final weather = await _weatherRepository.fetchWeatherByCityName(cityName);
      emit(WeatherLoaded(weather));
    } on NetworkException {
      emit(WeatherError("Error fetching weather!"));
    }
  }

  Future<void> getWeatherByLocation(String cityName) async {
    try {
      emit(WeatherLoading());
      final weather = await _weatherRepository.fetchWeatherByCityName(cityName);
      emit(WeatherLoaded(weather));
    } on NetworkException {
      emit(WeatherError("Error fetching weather!"));
    }
  }
}
