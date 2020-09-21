import 'package:app2/src/bloc/weather_bloc.dart';
import 'package:app2/src/data/weather.dart';
import 'package:app2/src/repository/fake_weather_repository.dart';
import 'package:app2/src/repository/open_weather_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocWeatherSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => buildWeatherBloc(),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  if (state is WeatherError) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return buildInitialInput();
                  } else if (state is WeatherLoading) {
                    return buildLoading();
                  } else if (state is WeatherLoaded) {
                    return buildColumnWithData(state.weather);
                  } else {
                    // (state is WeatherError)
                    return buildInitialInput();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  WeatherBloc buildWeatherBloc() {
    if (kReleaseMode) {
      return WeatherBloc(OpenWeatherRepository());
    } else {
      return WeatherBloc(FakeWeatherRepository());
    }
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
          key: Key("CityName"),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          key: Key("TemperatureText"),
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            key: Key("CityTextField"),
            onSubmitted: (value) => _getTemperatureByCityName(context, value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Enter a city",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            key: Key("CurrentLocationButton"),
            child: Text(
              "Use current location",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () => _getTemperatureByCurrentLocation(context),
            color: Theme.of(context).colorScheme.primary,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  void _getTemperatureByCityName(BuildContext context, String cityName) {
    // BlocProvider.of<WeatherCubit>(context);
    final weatherBloc = context.bloc<WeatherBloc>();
    weatherBloc.add(GetWeatherEventByCityName(cityName));
  }

  void _getTemperatureByCurrentLocation(BuildContext context) {
    // BlocProvider.of<WeatherCubit>(context);
    final weatherBloc = context.bloc<WeatherBloc>();
    weatherBloc.add(GetWeatherEventByCurrentLocation());
  }
}
