import 'package:integration_test_lab/features/profile/domain/entities/profile_entity.dart';
import 'package:integration_test_lab/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(ProfileEntity profile) async =>
      repository.updateProfile(profile);
}
