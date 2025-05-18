import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test_lab/core/consts/app_widget_keys.dart';
import 'package:integration_test_lab/core/router.dart';
import 'package:integration_test_lab/features/auth/presentation/providers/auth_provider.dart';
import 'package:integration_test_lab/features/profile/presentation/providers/profile_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasRequestedProfile = false;

  @override
  void initState() {
    super.initState();

    // Retrasamos la carga del perfil hasta que se construya la widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileIfNeeded();
    });
  }

  // Método para cargar el perfil si es necesario
  void _loadProfileIfNeeded() {
    if (!_hasRequestedProfile) {
      final authState = ref.read(authProvider);

      if (authState.user != null) {
        // Llamamos al método correcto: loadUserProfile
        ref.read(profileProvider.notifier).loadProfile(authState.user!.id);
        _hasRequestedProfile = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);

    if (authState.user == null && !authState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authState.user != null && !_hasRequestedProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProfileIfNeeded();
      });
    }

    if (profileState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

    return Scaffold(
      key: AppWidgetKeys.homeScreen,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            key: AppWidgetKeys.homeLogoutButton,
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              setState(() {
                _hasRequestedProfile = false;
              });
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
              'Bienvenido, ${profileState.profile?.name ?? authState.user?.name ?? "Usuario"}!',
              style: theme.textTheme.headlineLarge,
            ),
            Text(
              'Email: ${profileState.profile?.email ?? authState.user?.email ?? ""}',
            ),
            const Text(
              'Esta es la pantalla de inicio después de iniciar sesión con éxito',
            ),
            ElevatedButton.icon(
              key: AppWidgetKeys.homeProfileButton,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
              icon: const Icon(Icons.person),
              label: const Text('Editar perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
