import 'package:integration_test/core/consts/supabase_tables.dart';
import 'package:integration_test/core/utils/either.dart';
import 'package:integration_test/features/auth/domain/datasources/auth_data_source.dart';
import 'package:integration_test/core/domain/exceptions/domain_exceptions.dart';
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
      return false; // No hay forma de verificar si el correo está registrado
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: 'incorrect_password',
      );

      return response.user != null;
    } catch (e) {
      if (e.toString().toLowerCase().contains('user not found')) {
        return false;
      }

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

  @override
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      await _supabaseClient.from(SupabaseTables.profiles).insert({
        'user_id': userId,
        'name': name,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to create user profile: ${e.toString()}');
    }
  }

  @override
  Future<Either<DomainException, Map<String, dynamic>>> getUserProfile(
    String userId,
  ) async {
    try {
      final userData =
          await _supabaseClient
              .from(SupabaseTables.profiles)
              .select()
              .eq('user_id', userId)
              .single();

      return Right(userData);
    } catch (e) {
      return Left(
        GetProfileException('Failed to get user profile: ${e.toString()}'),
      );
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Añadimos timestamp de actualización
      final updatedData = {
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabaseClient
          .from(SupabaseTables.profiles)
          .update(updatedData)
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _supabaseClient
          .from(SupabaseTables.profiles)
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete user profile: ${e.toString()}');
    }
  }
}
