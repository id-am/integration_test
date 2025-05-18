import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';

import 'test_setup.dart';

void main() {
  group('Flujo de Autenticación', () {
    setUpAll(() async {
      await IntegrationTestSetup.initialize();
    });

    testWidgets('Login exitoso y navegación a Home', (
      WidgetTester tester,
    ) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Verificar que estamos en la pantalla de login
      expect(find.byKey(AppWidgetKeys.loginScreen), findsOneWidget);

      // Realizar login
      await IntegrationTestSetup.performLogin(tester);

      // Verificar que estamos en la pantalla Home
      expect(find.byKey(AppWidgetKeys.homeScreen), findsOneWidget);
    });

    testWidgets('Navegación a Perfil desde Home', (WidgetTester tester) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Realizar login
      await IntegrationTestSetup.performLogin(tester);

      // Navegar a la pantalla de perfil
      await tester.tap(find.byKey(AppWidgetKeys.homeProfileButton));
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla de perfil
      expect(find.byKey(AppWidgetKeys.profileScreen), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Logout exitoso', (WidgetTester tester) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Realizar login
      await IntegrationTestSetup.performLogin(tester);

      // Navegar a perfil
      await tester.tap(find.byKey(AppWidgetKeys.homeProfileButton));
      await tester.pumpAndSettle();
      expect(find.byKey(AppWidgetKeys.profileScreen), findsOneWidget);

      // Navegar de vuelta a Home
      await tester.tap(find.byKey(AppWidgetKeys.profileBackButton));
      await tester.pumpAndSettle();
      expect(find.byKey(AppWidgetKeys.homeScreen), findsOneWidget);

      // Realizar logout
      await tester.tap(find.byKey(AppWidgetKeys.homeLogoutButton));
      await tester.pumpAndSettle();

      // Verificar que volvimos a la pantalla de login
      expect(find.byKey(AppWidgetKeys.loginScreen), findsOneWidget);
    });
  });
}
