import 'package:app2/src/weather_page_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

export 'src/weather_page_widget.dart';

class App2Module extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => WeatherPageWidget()),
      ];
}
