import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test_lab/core/current_environment.dart';
import 'package:integration_test_lab/features/profile/data/datasources/supabase_profile_data_source.dart';
import 'package:integration_test_lab/features/profile/data/datasources/mock_profile_data_source.dart';
import 'package:integration_test_lab/features/profile/data/supabase_profile_repository.dart';
import 'package:integration_test_lab/features/profile/domain/datasources/profile_data_source.dart';
import 'package:integration_test_lab/features/profile/domain/models/profile_model.dart';
import 'package:integration_test_lab/features/profile/domain/repositories/profile_repository.dart';
import 'package:integration_test_lab/features/profile/domain/usecases/create_profile_usecase.dart';
import 'package:integration_test_lab/features/profile/domain/usecases/delete_profile_usecase.dart';
import 'package:integration_test_lab/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:integration_test_lab/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Profile data source provider
final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return CurrentEnvironment.isMock
      ? MockProfileDataSource()
      : SupabaseProfileDataSource(supabaseClient);
});

// Profile repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(profileDataSourceProvider);
  return SupabaseProfileRepository(dataSource);
});

// Profile use cases providers
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateProfileUseCase(repository);
});
final deleteProfileUseCaseProvider = Provider<DeleteProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return DeleteProfileUseCase(repository);
});
final createProfileUseCaseProvider = Provider<CreateProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return CreateProfileUseCase(repository);
});

// Profile state
class ProfileState {
  final ProfileModel? profile;
  final bool isLoading;
  final String? error;

  ProfileState({this.profile, this.isLoading = false, this.error});

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Profile notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final DeleteProfileUseCase _deleteProfileUseCase;
  final CreateProfileUseCase _createProfileUseCase;

  ProfileNotifier(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._deleteProfileUseCase,
    this._createProfileUseCase,
  ) : super(ProfileState());

  Future<void> loadProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _getProfileUseCase(userId);
      result.when(
        (error) =>
            state = state.copyWith(isLoading: false, error: error.message),
        (profile) => state = ProfileState(profile: profile),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateProfile(ProfileModel updatedProfile) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _updateProfileUseCase(updatedProfile);
      state = ProfileState(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _deleteProfileUseCase(userId);
      state = ProfileState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createProfile(ProfileModel newProfile) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _createProfileUseCase(
        newProfile.userId,
        newProfile.name,
        newProfile.email,
      );
      state = ProfileState(profile: newProfile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Profile provider
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  final getProfileUseCase = ref.watch(getProfileUseCaseProvider);
  final updateProfileUseCase = ref.watch(updateProfileUseCaseProvider);
  final deleteProfileUseCase = ref.watch(deleteProfileUseCaseProvider);
  final createProfileUseCase = ref.watch(createProfileUseCaseProvider);

  return ProfileNotifier(
    getProfileUseCase,
    updateProfileUseCase,
    deleteProfileUseCase,
    createProfileUseCase,
  );
});
