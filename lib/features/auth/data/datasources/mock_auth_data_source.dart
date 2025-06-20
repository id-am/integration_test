import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/auth/data/datasources/auth_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Mock de AuthDataSource que simula respuestas correctas para pruebas
class MockAuthDataSource implements AuthDataSource {
  // Usuario simulado para pruebas
  final User _mockUser = User(
    id: 'mock-user-id',
    email: 'test@example.com',
    aud: 'mock-aud',
    createdAt: DateTime.now().toIso8601String(),
    appMetadata: {},
    userMetadata: {},
  );

  bool _isAuthenticated = false;

  @override
  Future<Either<DomainException, User>> signInWithEmail(
    String email,
    String password,
  ) async {
    // Simulamos un error de inicio de sesión
    if (email == 'error@example.com') {
      return Left(LoginException('Credenciales inválidas'));
    }
    // Simulamos inicio de sesión exitoso
    _isAuthenticated = true;
    return Right(_mockUser);
  }

  @override
  Future<Either<DomainException, User>> signUpWithEmail(
    String email,
    String password,
  ) async {
    // Simulamos un error de registro
    if (email == 'error@example.com') {
      return Left(RegisterException('Error al registrar el usuario'));
    }
    // Simulamos registro exitoso
    _isAuthenticated = true;
    return Right(_mockUser);
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    // Simulamos que el email registered@example.com ya está registrado
    return email == 'registered@example.com';
  }

  @override
  Future<void> signOut() async {
    // Simulamos cierre de sesión
    _isAuthenticated = false;
  }

  @override
  Future<Either<DomainException, User>> getCurrentAuthUser() async {
    if (_isAuthenticated) {
      return Right(_mockUser);
    } else {
      return Left(GetUserException('No user is currently logged in'));
    }
  }
}
