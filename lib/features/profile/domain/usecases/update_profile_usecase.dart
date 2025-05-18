import 'package:integration_test_lab/features/profile/domain/models/profile_model.dart';
import 'package:integration_test_lab/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(ProfileModel profile) async =>
      repository.updateProfile(profile);
}
