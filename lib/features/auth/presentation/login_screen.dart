import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';
import 'package:integration_test_lab/core/router.dart';
import 'package:integration_test_lab/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .login(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, current) {
      if (current.user != null && !current.isLoading) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }

      if (current.error != null && !current.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: AppWidgetKeys.loginErrorSnackBar,
            content: Text(current.error!),
          ),
        );
      }
    });

    final authState = ref.watch(authProvider);

    final theme = Theme.of(context);

    return Scaffold(
      key: AppWidgetKeys.loginScreen,
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Iniciar sesión', style: theme.textTheme.headlineLarge),
              Icon(
                Icons.login,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      key: AppWidgetKeys.loginEmailField,
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo electrónico';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: AppWidgetKeys.loginPasswordField,
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: AppWidgetKeys.loginButton,
                        onPressed: authState.isLoading ? null : _handleLogin,
                        child:
                            authState.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Iniciar sesión'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      key: AppWidgetKeys.loginRegisterButton,
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.register);
                      },
                      child: const Text('No tienes una cuenta? Regístrate'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
