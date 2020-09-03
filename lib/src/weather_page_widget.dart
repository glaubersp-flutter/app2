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
  static const routeName = '/second';

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments ?? {};
    final String title =
        args.containsKey('title') ? args['title'] : "Second Page";
    final String message = args.containsKey('message')
        ? args['message']
        : "Message from Second Page";

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: BlocProvider(
          create: (_) => WeatherBloc(FakeWeatherRepository()),
          child: Center(
            child: Column(
              children: [
                Text("Hello, $message!"),
                BlocWeatherSearchPage(),
                RaisedButton(
                  child: Text("Back"),
                  onPressed: () {
                    Navigator.pop(context, 'Return from Second Page');
                  },
                )
              ],
            ),
          ),
        ));
  }
}
