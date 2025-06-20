import 'package:integration_test_lab/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email});

  // Factory constructor para crear un UserModel desde una entidad de Supabase
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(id: user.id, email: user.email ?? '');
  }

  // Convertir a entidad de dominio
  UserEntity toEntity() {
    return UserEntity(id: id, email: email);
  }

  // Json serialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'] as String, email: json['email'] as String);
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email};
  }
}
