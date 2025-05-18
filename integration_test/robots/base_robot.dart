import 'package:flutter_test/flutter_test.dart';

/// Clase base para los robots de prueba
abstract class BaseRobot {
  final WidgetTester tester;

  BaseRobot(this.tester);
}
