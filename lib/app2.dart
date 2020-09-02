import 'package:app2/src/secondPageWidget.dart';
import 'package:flutter_modular/flutter_modular.dart';

export 'src/secondPageWidget.dart';

class App2Module extends ChildModule {
  static Inject get to => Inject<App2Module>.of();

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, args) => SecondPageWidget()),
      ];
}
