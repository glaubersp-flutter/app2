library app2;

import 'package:app2/src/widget/bloc_weather_search_page.dart';
import 'package:app2/src/widget/cubit_weather_search_page.dart';
import 'package:flutter/material.dart';

class SecondPageArguments {
  final String title;
  final String message;

  SecondPageArguments(this.title, this.message);
}

class WeatherPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String title = getTitle(context);

    return Theme(
      data: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
              backgroundColor: Colors.white, primarySwatch: Colors.green)),
      child: Scaffold(
          appBar: AppBar(
            title: Text(title, key: Key("WeatherPageTitle")),
          ),
          // body: BlocWeatherSearchPage()),
          body: CubitWeatherSearchPage()),
    );
  }

  String getTitle(BuildContext context) {
    Map args;
    var modalRoute = ModalRoute.of(context);

    if (modalRoute != null) {
      args = modalRoute.settings.arguments ?? {};
    } else {
      args = {};
    }

    return args.containsKey('title') ? args['title'] : "Weather Example";
  }
}
