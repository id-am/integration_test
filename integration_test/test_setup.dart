import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';
import 'package:integration_test_lab/core/current_environment.dart';
import 'package:integration_test_lab/core/enums/environment_enum.dart';
import 'package:integration_test_lab/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Clase que maneja la configuración común para las pruebas de integración
class IntegrationTestSetup {
  /// Inicializa el entorno de pruebas con la configuración necesaria
  static Future<void> initialize() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Configurar el entorno en modo mock
    CurrentEnvironment.setEnvironment(EnvironmentEnum.mock);

    // Inicializar Supabase con credenciales de prueba
    await Supabase.initialize(
      url: 'https://your-project.supabase.co',
      anonKey: 'your-anon-key',
    );
  }

  /// Método helper para iniciar la aplicación en el estado inicial
  static Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();
  }

  /// Método helper para realizar el login en las pruebas
  static Future<void> performLogin(
    WidgetTester tester, {
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await tester.enterText(find.byKey(AppWidgetKeys.loginEmailField), email);
    await tester.enterText(
      find.byKey(AppWidgetKeys.loginPasswordField),
      password,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(AppWidgetKeys.loginButton));
    await tester.pumpAndSettle();
  }
}
