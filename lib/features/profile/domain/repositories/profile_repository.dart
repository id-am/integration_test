import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/profile/domain/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<DomainException, ProfileModel>> getProfile(String userId);
  Future<Either<DomainException, bool>> updateProfile(ProfileModel user);
  Future<Either<DomainException, bool>> deleteProfile(String userId);
  Future<Either<DomainException, bool>> createProfile(
    String userId,
    String name,
    String email,
  );
}
