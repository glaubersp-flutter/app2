import 'package:app2/app2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets('The main elements are shown on screen after loading',
      (WidgetTester tester) async {
    // Creating a MaterialApp containing our widget is needed to set the correct BuildContext.
    await tester.pumpWidget(MaterialApp(home: WeatherPageWidget()));

    var weatherPageTitleFinder = find.byKey(Key("WeatherPageTitle"));
    var cityTextFieldFinder = find.byKey(Key("CityTextField"));
    var curLocationBtnFinder = find.byKey(Key("CurrentLocationButton"));

    expect(weatherPageTitleFinder, findsOneWidget);
    expect(cityTextFieldFinder, findsOneWidget);
    expect(curLocationBtnFinder, findsOneWidget);
  });

  testWidgets(
      'Filling a city and pressing Search on virtual keyboard should show the city and its temperature.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeatherPageWidget()));

    var cityTextFieldFinder = find.byKey(Key("CityTextField"));

    var cityName = find.byKey(Key("CityName"));
    var temperature = find.byKey(Key("TemperatureText"));

    await tester.enterText(cityTextFieldFinder, "Campinas");
    await tester.pump();

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(cityName, findsOneWidget);
    expect(temperature, findsOneWidget);
  });

  testWidgets(
      'Clicking Use current location should show current city and temperature.',
      (WidgetTester tester) async {
    var curLocationBtnFinder = find.byKey(Key("CurrentLocationButton"));
    var cityName = find.byKey(Key("CityName"));
    var temperature = find.byKey(Key("TemperatureText"));

    await tester.pumpWidget(MaterialApp(home: WeatherPageWidget()));
    await tester.tap(curLocationBtnFinder);
    await tester.pumpAndSettle();

    expect(cityName, findsOneWidget);
    expect(temperature, findsOneWidget);
  });
}
