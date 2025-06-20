import 'package:integration_test_lab/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.userId,
    required super.email,
    required super.name,
  });

  // Convertir a entidad de dominio
  ProfileEntity toEntity() {
    return ProfileEntity(userId: userId, email: email, name: name);
  }

  // Json serialization
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'email': email, 'name': name};
  }

  // Constructor a partir de entidad
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
    );
  }
}
