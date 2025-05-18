import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/features/auth/presentation/login_screen.dart';
import 'package:integration_test/features/auth/presentation/register_screen.dart';
import 'package:integration_test/features/home/presentation/home_screen.dart';
import 'package:integration_test/features/profile/presentation/profile_screen.dart';

// Route names
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
}

// Router configuration
final routerProvider = Provider<Map<String, WidgetBuilder>>((ref) {
  return {
    AppRoutes.login: (context) => const LoginScreen(),
    AppRoutes.register: (context) => const RegisterScreen(),
    AppRoutes.home: (context) => const HomeScreen(),
    AppRoutes.profile: (context) => const ProfileScreen(),
  };
});
