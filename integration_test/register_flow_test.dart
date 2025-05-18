import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';
import 'robots/login_robot.dart';
import 'robots/register_robot.dart';
import 'test_setup.dart';

void main() {
  group('Flujo de Registro', () {
    setUpAll(() async {
      await IntegrationTestSetup.initialize();
    });

    testWidgets('Registro exitoso y navegación a Home', (
      WidgetTester tester,
    ) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Crear instancia del robot de registro
      final registerRobot = RegisterRobot(tester);

      // Navegar a la pantalla de registro
      await registerRobot.navigateToRegister();

      // Realizar registro
      await registerRobot.performRegister();

      // Verificar que estamos en la pantalla Home
      expect(find.byKey(AppWidgetKeys.homeScreen), findsOneWidget);
    });

    testWidgets('Registro falla, email ya registrado', (
      WidgetTester tester,
    ) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Crear instancia del robot de registro
      final registerRobot = RegisterRobot(tester);
      final loginRobot = LoginRobot(tester);

      // Navegar a la pantalla de registro
      await registerRobot.navigateToRegister();

      // Intentar registrar con un email ya existente
      await registerRobot.performRegister(email: 'registered@example.com');

      // Verificar que navega a la pantalla de login
      await loginRobot.verifyLoginScreen();
    });

    testWidgets('Navegación de login a registro y registro a login', (
      WidgetTester tester,
    ) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Crear instancia del robot de registro
      final registerRobot = RegisterRobot(tester);

      // Crear instancia del robot de login
      final loginRobot = LoginRobot(tester);

      await loginRobot.verifyLoginScreen();
      // Navegar a la pantalla de registro
      await loginRobot.navigateToRegister();

      // Verificar que estamos en la pantalla de registro
      await registerRobot.verifyRegisterScreen();

      // Navegar a login
      await registerRobot.navigateToLogin();

      // Verificar que estamos en la pantalla de login
      await loginRobot.verifyLoginScreen();
    });

    testWidgets('Validación de campos requeridos', (WidgetTester tester) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Crear instancia del robot de registro
      final registerRobot = RegisterRobot(tester);

      // Navegar a la pantalla de registro
      await registerRobot.navigateToRegister();

      // Intentar registrar sin datos
      await registerRobot.tapRegisterButton();

      // Verificar que se muestran los mensajes de error
      expect(find.text('Por favor ingrese su nombre'), findsOneWidget);
      expect(
        find.text('Por favor ingrese su correo electrónico'),
        findsOneWidget,
      );
      expect(find.text('Por favor ingrese su contraseña'), findsOneWidget);
    });

    testWidgets('Validación de contraseña corta', (WidgetTester tester) async {
      // Iniciar la aplicación
      await IntegrationTestSetup.pumpApp(tester);

      // Crear instancia del robot de registro
      final registerRobot = RegisterRobot(tester);

      await registerRobot.navigateToRegister();

      // Intentar registrar con contraseña corta
      await registerRobot.performRegister(
        name: 'Test User',
        email: 'test@example.com',
        password: '12345', // Contraseña menor a 6 caracteres
      );

      // Verificar que se muestra el mensaje de error
      expect(
        find.text('La contraseña debe tener al menos 6 caracteres'),
        findsOneWidget,
      );
    });
  });
}
