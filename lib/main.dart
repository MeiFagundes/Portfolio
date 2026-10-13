import 'package:flutter/widgets.dart';

import 'app/bootstrap.dart';
import 'app/dependencies.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PortfolioBootstrap(initialize: createAppDependencies));
}
