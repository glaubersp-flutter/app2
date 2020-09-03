import 'package:app2/src/weather_page_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

export 'src/weather_page_widget.dart';

class App2Module extends ChildModule {
  static Inject get to => Inject<App2Module>.of();

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, args) => WeatherPageWidget()),
      ];
}
