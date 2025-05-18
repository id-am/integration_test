import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test_lab/core/config.dart';
import 'package:integration_test_lab/core/presentation/app_theme.dart';
import 'package:integration_test_lab/core/router.dart';
import 'package:integration_test_lab/features/auth/presentation/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routerProvider);

    return MaterialApp(
      title: 'Supabase Auth Demo',
      theme: AppTheme.theme,
      home: const LoginScreen(),
      routes: routes,
    );
  }
}
