import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/profile/domain/repositories/profile_repository.dart';

class DeleteProfileUseCase {
  final ProfileRepository repository;

  DeleteProfileUseCase(this.repository);

  Future<Either<DomainException, bool>> call(String userId) async =>
      repository.deleteProfile(userId);
}
