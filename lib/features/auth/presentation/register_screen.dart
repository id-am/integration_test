import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';
import 'package:integration_test_lab/core/router.dart';
import 'package:integration_test_lab/features/auth/presentation/providers/auth_provider.dart';
import 'package:integration_test_lab/features/profile/domain/entities/profile_entity.dart';
import 'package:integration_test_lab/features/profile/presentation/providers/profile_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .register(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, current) {
      // If user is registered, navigate to home
      if (current.user != null && !current.isLoading) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }

      // Si se debe redirigir al login porque el email ya está registrado
      if (current.redirectToLogin && !current.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              current.error ??
                  'El correo ya está registrado. Redirigiendo al login...',
            ),
          ),
        );

        // Esperamos un momento para mostrar el mensaje antes de redirigir

        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
      // Mostrar error si el registro falla por otras razones
      else if (current.error != null && !current.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: AppWidgetKeys.registerErrorSnackBar,
            content: Text(current.error!),
          ),
        );
      } else if (!current.isLoading && current.redirectToHome) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            key: AppWidgetKeys.registerSuccessSnackBar,
            content: Text('Registro exitoso.'),
          ),
        );

        final profile = ProfileEntity(
          userId: current.user!.id,
          email: _emailController.text,
          name: _nameController.text,
        );

        ref.read(profileProvider.notifier).createProfile(profile);

        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });

    final authState = ref.watch(authProvider);

    final theme = Theme.of(context);

    return Scaffold(
      key: AppWidgetKeys.registerScreen,
      appBar: AppBar(title: const Text('Registrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Text('Crear cuenta', style: theme.textTheme.headlineLarge),
              Text(
                'Regístrate para acceder a todas las funciones',
                style: theme.textTheme.bodyLarge,
              ),
              Icon(
                Icons.account_circle,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    TextFormField(
                      key: AppWidgetKeys.registerNameField,
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: AppWidgetKeys.registerEmailField,
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo electrónico';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: AppWidgetKeys.registerPasswordField,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      key: AppWidgetKeys.registerButton,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleRegister,
                        child:
                            authState.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Registrar'),
                      ),
                    ),
                    TextButton(
                      key: AppWidgetKeys.registerLoginButton,
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.login);
                      },
                      child: const Text(
                        '¿Ya tienes una cuenta? Iniciar sesión',
                      ),
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
