import 'dart:convert';

import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart' as geolocator;

WeatherRepository getWeatherRepository() => OpenWeatherRepository();

class OpenWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeatherByCityName(String cityName) async {
    List<Location> locations;
    try {
      locations = await locationFromAddress(cityName);
    } catch (e) {
      throw NetworkException();
    }
    if (locations.isEmpty) {
      throw NetworkException();
    }

    var location = locations.first;
    var response = await queryRemoteTemperature(location.latitude,
        location.longitude, WeatherRepository.part, WeatherRepository.apiKey);
    if (response.statusCode != 200) {
      throw NetworkException();
    }

    return Weather.fromJson(cityName, json.decode(response.body));
  }

  @override
  Future<Weather> fetchWeatherByLocation() async {
    geolocator.Position position;
    try {
      position = await _getCurrentLocation();
    } on MissingPluginException {
      throw NetworkException();
    }
    if (position == null) {
      throw NetworkException();
    }

    Placemark addressFromPosition = await _getAddressFromPosition(position);

    var response = await queryRemoteTemperature(position.latitude,
        position.longitude, WeatherRepository.part, WeatherRepository.apiKey);

    if (response.statusCode != 200) {
      throw NetworkException();
    }
    return Future.value(Weather.fromJson(
        addressFromPosition.locality, json.decode(response.body)));
  }

  Future<geolocator.Position> _getCurrentLocation() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high);
    return position;
  }

  Future<Placemark> _getAddressFromPosition(
      geolocator.Position position) async {
    List<Placemark> p =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return p.first;
  }
}
