import 'package:integration_test/core/utils/either.dart';
import 'package:integration_test/core/domain/exceptions/domain_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  /// Inicia sesión con correo electrónico y contraseña
  Future<Either<DomainException, User>> signInWithEmail(
    String email,
    String password,
  );

  /// Registra un nuevo usuario con correo electrónico y contraseña
  Future<Either<DomainException, User>> signUpWithEmail(
    String email,
    String password,
  );

  /// Verifica si un email ya está registrado
  Future<bool> isEmailRegistered(String email);

  /// Cierra la sesión del usuario actual
  Future<void> signOut();

  /// Obtiene el usuario actualmente autenticado
  Future<Either<DomainException, User>> getCurrentAuthUser();

  /// Crea un perfil de usuario en la base de datos
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
  });

  /// Obtiene el perfil del usuario por ID
  Future<Either<DomainException, Map<String, dynamic>>> getUserProfile(
    String userId,
  );

  /// Actualiza el perfil del usuario
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  });

  /// Elimina el perfil del usuario
  Future<void> deleteUserProfile(String userId);
}
