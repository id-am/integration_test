import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/core/current_environment.dart';
import 'package:integration_test/features/auth/domain/datasources/auth_data_source.dart';
import 'package:integration_test/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'package:integration_test/features/auth/data/datasources/mock_auth_data_source.dart';
import 'package:integration_test/features/auth/data/supabase_auth_repository.dart';
import 'package:integration_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:integration_test/features/auth/domain/models/user_model.dart';
import 'package:integration_test/features/auth/domain/usecases/usecases.dart';
import 'package:integration_test/core/domain/exceptions/domain_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Auth data source provider
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return CurrentEnvironment.isMock
      ? MockAuthDataSource()
      : SupabaseAuthDataSource(supabaseClient);
});

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return SupabaseAuthRepository(dataSource);
});

// Auth use cases providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

// Auth state notifier
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool redirectToLogin;
  final bool redirectToHome;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.redirectToLogin = false,
    this.redirectToHome = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? redirectToLogin,
    bool? redirectToHome,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      redirectToLogin: redirectToLogin ?? this.redirectToLogin,
      redirectToHome: redirectToHome ?? this.redirectToHome,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier(
    this._getCurrentUserUseCase,
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
  ) : super(AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _getCurrentUserUseCase();
      result.when(
        (error) => state = AuthState(error: error.message),
        (user) => state = AuthState(user: user),
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _loginUseCase(email, password);

      result.when(
        (error) =>
            state = state.copyWith(isLoading: false, error: error.message),
        (user) => state = AuthState(user: user),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      redirectToLogin: false,
    );

    final result = await _registerUseCase(email, password);
    result.when(
      (e) {
        if (e is EmailAlreadyRegisteredException ||
            e.toString().contains('ya está registrado')) {
          state = state.copyWith(
            isLoading: false,
            error: e.toString(),
            redirectToLogin: true,
          );
        } else {
          state = state.copyWith(isLoading: false, error: e.toString());
        }
      },
      (user) {
        final newUser = UserModel(id: user.id, email: user.email, name: name);
        state = state.copyWith(
          user: newUser,
          isLoading: false,
          error: null,
          redirectToLogin: false,
          redirectToHome: true,
        );
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _logoutUseCase.call();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final registerUseCase = ref.watch(registerUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);

  return AuthNotifier(
    getCurrentUserUseCase,
    loginUseCase,
    registerUseCase,
    logoutUseCase,
  );
});
