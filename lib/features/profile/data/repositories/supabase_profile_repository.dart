import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/profile/data/datasources/profile_data_source.dart';
import 'package:integration_test_lab/features/profile/data/models/profile_model.dart';
import 'package:integration_test_lab/features/profile/domain/entities/profile_entity.dart';
import 'package:integration_test_lab/features/profile/domain/repositories/profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final ProfileDataSource _dataSource;

  SupabaseProfileRepository(this._dataSource);

  @override
  Future<Either<DomainException, bool>> createProfile(
    String userId,
    String name,
    String email,
  ) async {
    try {
      final profile = ProfileModel(userId: userId, name: name, email: email);
      return Right(await _dataSource.createProfile(profile: profile));
    } catch (e) {
      return Left(
        CreateProfileException(
          'Failed to create user profile: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, ProfileEntity>> getProfile(
    String userId,
  ) async {
    try {
      final userData = await _dataSource.getProfile(userId);

      return Right(ProfileModel.fromJson(userData).toEntity());
    } catch (e) {
      return Left(
        GetProfileException('Failed to get user profile: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, bool>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      final profileModel = ProfileModel.fromEntity(profile);
      final result = await _dataSource.updateProfile(profile: profileModel);
      return Right(result);
    } catch (e) {
      return Left(
        UpdateProfileException(
          'Failed to update user profile: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, bool>> deleteProfile(String userId) async {
    try {
      await _dataSource.deleteProfile(userId);
      return Right(true);
    } catch (e) {
      return Left(
        DeleteProfileException(
          'Failed to delete user profile: ${e.toString()}',
        ),
      );
    }
  }
}
