import 'package:integration_test/core/consts/supabase_tables.dart';
import 'package:integration_test/core/utils/either.dart';
import 'package:integration_test/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test/features/profile/domain/datasources/profile_data_source.dart';
import 'package:integration_test/features/profile/domain/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileDataSource implements ProfileDataSource {
  final SupabaseClient _supabaseClient;

  SupabaseProfileDataSource(this._supabaseClient);

  @override
  Future<bool> createProfile({required ProfileModel user}) async {
    try {
      await _supabaseClient.from(SupabaseTables.profiles).insert({
        'user_id': user.userId,
        'name': user.name,
        'email': user.email,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final userData =
          await _supabaseClient
              .from(SupabaseTables.profiles)
              .select()
              .eq('user_id', userId)
              .single();

      return userData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateProfile({required ProfileModel user}) async {
    try {
      final updatedData = {
        ...user.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabaseClient
          .from(SupabaseTables.profiles)
          .update(updatedData)
          .eq('user_id', user.userId);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteProfile(String userId) async {
    try {
      await _supabaseClient
          .from(SupabaseTables.profiles)
          .delete()
          .eq('user_id', userId);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
