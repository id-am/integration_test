import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<DomainException, ProfileEntity>> getProfile(String userId);
  Future<Either<DomainException, bool>> updateProfile(ProfileEntity profile);
  Future<Either<DomainException, bool>> deleteProfile(String userId);
  Future<Either<DomainException, bool>> createProfile(
    String userId,
    String name,
    String email,
  );
}
