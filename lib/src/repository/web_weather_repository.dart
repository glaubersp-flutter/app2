import 'dart:convert';

import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_search/mapbox_search.dart';

WeatherRepository getWeatherRepository() => WebWeatherRepository();

class WebWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeatherByCityName(String cityName) async {
    List<MapBoxPlace> places = await _getPlacesByCityName(cityName);
    if (places.isEmpty) {
      throw NetworkException();
    }

    var firstMatchedPlace = places.first;
    double latitude = firstMatchedPlace.geometry.coordinates[1];
    double longitude = firstMatchedPlace.geometry.coordinates[0];

    http.Response response = await queryRemoteTemperature(
        latitude, longitude, WeatherRepository.part, WeatherRepository.apiKey);
    if (response.statusCode != 200) {
      throw NetworkException();
    }
    return Future.value(
        Weather.fromJson(firstMatchedPlace.text, json.decode(response.body)));
  }

  @override
  Future<Weather> fetchWeatherByLocation() async {
    var position = await _determineCurrentPosition();

    http.Response response = await queryRemoteTemperature(position.latitude,
        position.longitude, WeatherRepository.part, WeatherRepository.apiKey);
    if (response.statusCode != 200) {
      throw NetworkException();
    }

    List<MapBoxPlace> places = await _getAddressesByPosition(position);
    var firstMatchedPlaceName;
    if (places.isEmpty) {
      firstMatchedPlaceName = "Unknown Place";
    } else {
      firstMatchedPlaceName = places.first.text;
    }
    return Future.value(Weather.fromJson(
        firstMatchedPlaceName, json.decode(response.body)));
  }

  Future<List<MapBoxPlace>> _getPlacesByCityName(String cityName) async {
    final PlacesSearch placesSearch = PlacesSearch(
        apiKey:
            '',
        limit: 5,
        country: "BR",
        language: "pt-BR");
    List<MapBoxPlace> places = await placesSearch.getPlaces(cityName);
    return places;
  }

  Future<List<MapBoxPlace>> _getAddressesByPosition(Position position) async {
    var reverseGeoCoding = ReverseGeoCoding(
        apiKey:
            '',
        limit: 5,
        country: "BR",
        language: "pt-BR");

    List<MapBoxPlace> places = await reverseGeoCoding.getAddress(
      Location(lat: position.latitude, lng: position.longitude),
    );
    return places;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determineCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      // return Future.error(
      //     'Location services are not available in this platform.');
      throw NetworkException();
    }
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
