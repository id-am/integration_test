import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/profile/domain/entities/profile_entity.dart';
import 'package:integration_test_lab/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<DomainException, ProfileEntity>> call(String userId) async =>
      repository.getProfile(userId);
}
