import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_setup.dart';
import 'auth_flow_test.dart' as auth_flow;
import 'register_flow_test.dart' as register_flow;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await IntegrationTestSetup.initialize();
  });

  // Ejecutar todas las suites de prueba
  group('Suite de Pruebas de Integración', () {
    auth_flow.main();
    register_flow.main();
  });
}
