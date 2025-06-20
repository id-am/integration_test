import 'package:integration_test_lab/features/profile/data/datasources/profile_data_source.dart';
import 'package:integration_test_lab/features/profile/data/models/profile_model.dart';

/// Mock de ProfileDataSource que simula respuestas correctas para pruebas
class MockProfileDataSource implements ProfileDataSource {
  // Mapa para almacenar perfiles simulados - userId: ProfileModel
  final Map<String, Map<String, dynamic>> _mockProfiles = {
    'mock-user-id': {
      'user_id': 'mock-user-id',
      'name': 'Test User',
      'email': 'test@example.com',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': null,
    },
  };

  @override
  Future<bool> createProfile({required ProfileModel profile}) async {
    // Simulamos creación exitosa añadiendo el perfil a nuestro mapa
    _mockProfiles[profile.userId] = {
      'user_id': profile.userId,
      'name': profile.name,
      'email': profile.email,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': null,
    };
    return true;
  }

  @override
  Future<Map<String, dynamic>> getProfile(String userId) async {
    // Verificamos si el perfil existe en nuestro mapa
    if (_mockProfiles.containsKey(userId)) {
      return _mockProfiles[userId]!;
    }

    // Si no existe, simulamos un error
    throw Exception('Profile not found');
  }

  @override
  Future<bool> updateProfile({required ProfileModel profile}) async {
    // Verificamos si el perfil existe en nuestro mapa
    if (_mockProfiles.containsKey(profile.userId)) {
      // Actualizamos el perfil
      _mockProfiles[profile.userId] = {
        ..._mockProfiles[profile.userId]!,
        ...profile.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      return true;
    }

    // Si no existe, simulamos un error
    throw Exception('Profile not found');
  }

  @override
  Future<bool> deleteProfile(String userId) async {
    // Verificamos si el perfil existe en nuestro mapa
    if (_mockProfiles.containsKey(userId)) {
      // Eliminamos el perfil
      _mockProfiles.remove(userId);
      return true;
    }

    // Si no existe, simulamos un error
    throw Exception('Profile not found');
  }
}
