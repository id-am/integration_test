import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';
import 'base_robot.dart';

/// Robot que maneja las operaciones relacionadas con el registro
class RegisterRobot extends BaseRobot {
  RegisterRobot(super.tester);

  /// Verifica que estamos en la pantalla de registro
  Future<void> verifyRegisterScreen() async {
    expect(find.byKey(AppWidgetKeys.registerScreen), findsOneWidget);
  }

  /// Navegar desde login a registro
  Future<void> navigateToRegister() async {
    await tester.tap(find.byKey(AppWidgetKeys.loginRegisterButton));
    await tester.pumpAndSettle();
    expect(find.byKey(AppWidgetKeys.registerScreen), findsOneWidget);
  }

  /// Ingresa los datos de registro
  Future<void> enterRegistrationData({
    String name = 'Test User',
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await tester.enterText(find.byKey(AppWidgetKeys.registerNameField), name);
    await tester.enterText(find.byKey(AppWidgetKeys.registerEmailField), email);
    await tester.enterText(
      find.byKey(AppWidgetKeys.registerPasswordField),
      password,
    );
    await tester.pumpAndSettle();
  }

  /// Presiona el botón de registro
  Future<void> tapRegisterButton() async {
    await tester.tap(find.byKey(AppWidgetKeys.registerButton));
    await tester.pumpAndSettle();
  }

  /// Realiza el proceso completo de registro
  Future<void> performRegister({
    String name = 'Test User',
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await verifyRegisterScreen();
    await enterRegistrationData(name: name, email: email, password: password);
    await tapRegisterButton();
  }

  /// Verifica que se muestra el mensaje de éxito
  Future<void> verifySuccessMessage() async {
    expect(find.byKey(AppWidgetKeys.registerSuccessSnackBar), findsOneWidget);
  }

  /// Verifica que se muestra el mensaje de error
  Future<void> verifyErrorMessage() async {
    expect(find.byKey(AppWidgetKeys.registerErrorSnackBar), findsOneWidget);
  }

  /// Navega a la pantalla de login desde registro
  Future<void> navigateToLogin() async {
    await tester.tap(find.byKey(AppWidgetKeys.registerLoginButton));
    await tester.pumpAndSettle();
  }
}
