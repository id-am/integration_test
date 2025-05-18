import 'package:integration_test/features/profile/domain/datasources/profile_data_source.dart';
import 'package:integration_test/features/profile/domain/models/profile_model.dart';

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
  Future<bool> createProfile({required ProfileModel user}) async {
    // Simulamos creación exitosa añadiendo el perfil a nuestro mapa
    _mockProfiles[user.userId] = {
      'user_id': user.userId,
      'name': user.name,
      'email': user.email,
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
  Future<bool> updateProfile({required ProfileModel user}) async {
    // Verificamos si el perfil existe en nuestro mapa
    if (_mockProfiles.containsKey(user.userId)) {
      // Actualizamos el perfil
      _mockProfiles[user.userId] = {
        ..._mockProfiles[user.userId]!,
        ...user.toJson(),
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
