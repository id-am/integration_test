import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/core/router.dart';
import 'package:integration_test/features/auth/presentation/providers/auth_provider.dart';
import 'package:integration_test/features/profile/presentation/providers/profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final profileState = ref.watch(profileProvider);

    // If user is not logged in, redirect to login screen
    if (authState.user == null && !authState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              'Bienvenido, ${profileState.profile?.name ?? "User"}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text('Email: ${profileState.profile?.email ?? ""}'),
            const Text(
              'Esta es la pantalla de inicio después de iniciar sesión con éxito',
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
              icon: const Icon(Icons.person),
              label: const Text('Editar perfil'),
            ),
            const Text(
              'Esta aplicación usa Clean Architecture con Gateway/DataSource',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
