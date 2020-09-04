library app2;

import 'package:app2/src/bloc/weather_bloc.dart';
import 'package:app2/src/repository/weather_repository.dart';
import 'package:app2/src/widget/bloc_weather_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecondPageArguments {
  final String title;
  final String message;

  SecondPageArguments(this.title, this.message);
}

class WeatherPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments ?? {};
    final String title =
        args.containsKey('title') ? args['title'] : "Weather Example";

    return Theme(
      data: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
              backgroundColor: Colors.white, primarySwatch: Colors.green)),
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: BlocProvider(
            create: (_) => WeatherBloc(OpenWeatherRepository()),
            child: Center(
              child: Column(
                children: [
                  BlocWeatherSearchPage(),
                ],
              ),
            ),
          )),
    );
  }
}
