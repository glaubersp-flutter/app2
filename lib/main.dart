import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app2module.dart';
import 'app2widget.dart';

void main() => runApp(ModularApp(module: App2Module(), child: App2Widget()));