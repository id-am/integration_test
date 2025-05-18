import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';
import 'base_robot.dart';

/// Robot que maneja las operaciones relacionadas con el login
class LoginRobot extends BaseRobot {
  LoginRobot(super.tester);

  /// Verifica que estamos en la pantalla de login
  Future<void> verifyLoginScreen() async {
    expect(find.byKey(AppWidgetKeys.loginScreen), findsOneWidget);
  }

  /// Ingresa las credenciales en los campos de login
  Future<void> enterCredentials({
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await tester.enterText(find.byKey(AppWidgetKeys.loginEmailField), email);
    await tester.enterText(
      find.byKey(AppWidgetKeys.loginPasswordField),
      password,
    );
    await tester.pumpAndSettle();
  }

  /// Presiona el botón de login
  Future<void> tapLoginButton() async {
    await tester.tap(find.byKey(AppWidgetKeys.loginButton));
    await tester.pumpAndSettle();
  }

  /// Realiza el proceso completo de login
  Future<void> performLogin({
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await verifyLoginScreen();
    await enterCredentials(email: email, password: password);
    await tapLoginButton();
  }
}
