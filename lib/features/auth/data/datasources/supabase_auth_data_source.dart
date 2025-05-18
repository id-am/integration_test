import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/features/auth/domain/datasources/auth_data_source.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDataSource implements AuthDataSource {
  final SupabaseClient _supabaseClient;

  SupabaseAuthDataSource(this._supabaseClient);

  @override
  Future<Either<DomainException, User>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left(LoginException('Login failed'));
      }

      return Right(response.user!);
    } catch (e) {
      return Left(LoginException('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DomainException, User>> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left(RegisterException('Registration failed'));
      }

      return Right(response.user!);
    } catch (e) {
      return Left(RegisterException('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
      return true; // Si no lanza excepción, el correo existe
    } catch (e) {
      // Si el error indica que el usuario no existe, retornamos false
      if (e.toString().toLowerCase().contains('user not found') ||
          e.toString().toLowerCase().contains('email not found')) {
        return false;
      }
      // Para otros errores (como problemas de red), asumimos que el correo existe
      // para evitar falsos negativos
      return true;
    }
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  Future<Either<DomainException, User>> getCurrentAuthUser() async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;

      if (currentUser == null) {
        return Left(GetUserException('No user is currently logged in'));
      }

      return Right(currentUser);
    } catch (e) {
      return Left(
        GetUserException('Failed to get current user: ${e.toString()}'),
      );
    }
  }
}
