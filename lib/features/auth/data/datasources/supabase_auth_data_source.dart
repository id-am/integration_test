import 'package:integration_test_lab/core/supabase_tables.dart';
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
      final userData =
          await _supabaseClient
              .from(SupabaseTables.profiles)
              .select()
              .eq('email', email)
              .single();
      return userData.isEmpty ? false : true;
    } catch (e) {
      return false;
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
