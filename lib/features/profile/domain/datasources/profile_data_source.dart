import 'package:integration_test/features/profile/domain/models/profile_model.dart';

abstract class ProfileDataSource {
  /// Crea un perfil de usuario en la base de datos
  Future<bool> createProfile({required ProfileModel user});

  /// Obtiene el perfil del usuario por ID
  Future<Map<String, dynamic>> getProfile(String userId);

  /// Actualiza el perfil del usuario
  Future<bool> updateProfile({required ProfileModel user});

  /// Elimina el perfil del usuario
  Future<bool> deleteProfile(String userId);
}
