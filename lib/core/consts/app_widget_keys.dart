import 'package:flutter/material.dart';

class AppWidgetKeys {
  // Login Screen Keys
  static const Key loginScreen = Key('login_screen');
  static const Key loginEmailField = Key('login_email_field');
  static const Key loginPasswordField = Key('login_password_field');
  static const Key loginButton = Key('login_button');
  static const Key loginErrorSnackBar = Key('login_error_snackbar');
  static const Key loginRegisterButton = Key('login_register_button');
  // Register Screen Keys
  static const Key registerScreen = Key('register_screen');
  static const Key registerNameField = Key('register_name_field');
  static const Key registerEmailField = Key('register_email_field');
  static const Key registerPasswordField = Key('register_password_field');
  static const Key registerButton = Key('register_button');
  static const Key registerErrorSnackBar = Key('register_error_snackbar');
  static const Key registerSuccessSnackBar = Key('register_success_snackbar');
  static const Key registerLoginButton = Key('register_login_button');
  // Home Screen Keys
  static const Key homeScreen = Key('home_screen');
  static const Key homeLogoutButton = Key('home_logout_button');
  static const Key homeProfileButton = Key('home_profile_button');
  // Profile Screen Keys
  static const Key profileScreen = Key('profile_screen');
  static const Key profileBackButton = Key('profile_back_button');
  static const Key profileNameField = Key('profile_name_field');
  static const Key profileEmailField = Key('profile_email_field');
  static const Key profileSaveButton = Key('profile_save_button');
}
