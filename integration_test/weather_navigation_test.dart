// import 'dart:io';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
//
// // The application under test.
// import 'package:app2/app2module.dart' as app;
//
// takeScreenshot(WidgetTester driver, String path) async {
//   final List<int> pixels = await driver.screenshot();
//   final File file = new File(path);
//   await file.writeAsBytes(pixels);
//   print(path);
// }
//
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   setUpAll(() async {
//     new Directory('screenshots').create();
//   });
//
//   group('Weather app demo', () {
//     testWidgets('tap on the floating action button; verify counter',
//         (WidgetTester tester) async {
//       app.main();
//       await tester.pumpAndSettle();
//     });
//
//     test('check flutter driver health', () async {
//       Health health = await driver.checkHealth();
//       print(health.status);
//     });
//
//     test('Navigate to weather app.', () async {
//       var login = find.byType("RaisedButton");
//       var listTitleBar = find.text('App list');
//       var weatherApp = find.text("Weather Example");
//       var currLocationBtn = find.byValueKey("CurrentLocationButton");
//
//       await takeScreenshot(driver, 'screenshots/01_initial_page.png');
//       await driver.tap(login);
//       await driver.waitFor(listTitleBar);
//       await takeScreenshot(driver, 'screenshots/02_app_list.png');
//       await driver.tap(weatherApp);
//       await takeScreenshot(driver, 'screenshots/03_weather_app.png');
//       await driver.waitFor(currLocationBtn);
//     });
//   });
// }
