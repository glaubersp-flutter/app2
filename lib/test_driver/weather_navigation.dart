import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart'; // https://github.com/flutter/flutter/issues/27826

takeScreenshot(FlutterDriver driver, String path) async {
  final List<int> pixels = await driver.screenshot();
  final File file = new File(path);
  await file.writeAsBytes(pixels);
  print(path);
}

void main() {
  group('Weather app demo', () {
    FlutterDriver driver;

    setUpAll(() async {
      new Directory('screenshots').create();
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test('Navigate to weather app.', () async {
      var login = find.byType("RaisedButton");
      var listTitleBar = find.text('App list');
      var weatherApp = find.text("Weather Example");
      var currLocationBtn = find.byValueKey("CurrentLocationButton");

      await takeScreenshot(driver, 'screenshots/01_initial_page.png');
      await driver.tap(login);
      await driver.waitFor(listTitleBar);
      await takeScreenshot(driver, 'screenshots/02_app_list.png');
      await driver.tap(weatherApp);
      await takeScreenshot(driver, 'screenshots/03_weather_app.png');
      await driver.waitFor(currLocationBtn);
    });
  });
}
