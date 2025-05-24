import 'package:integration_test_lab/core/enums/environment_enum.dart';

class CurrentEnvironment {
  static EnvironmentEnum environment = EnvironmentEnum.development;

  static bool get isMock => environment == EnvironmentEnum.mock;

  static bool get isDevelopment => environment == EnvironmentEnum.development;

  static void setEnvironment(EnvironmentEnum env) {
    environment = env;
  }
}
