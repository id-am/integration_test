import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test_lab/features/profile/domain/models/profile_model.dart';
import 'package:integration_test_lab/features/auth/presentation/providers/auth_provider.dart';
import 'package:integration_test_lab/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    // Initialize with current auth user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ref.read(profileProvider.notifier).loadProfile(authState.user!.id);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Update text controllers when profile data is loaded
  void _updateControllers(ProfileModel profile) {
    _nameController.text = profile.name;
    _emailController.text = profile.email;
  }

  void _handleSaveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileState = ref.read(profileProvider);
      final authState = ref.read(authProvider);

      if (profileState.profile != null && authState.user != null) {
        final updatedProfile = ProfileModel(
          userId: authState.user!.id,
          name: _nameController.text,
          email: _emailController.text,
        );
        ref.read(profileProvider.notifier).updateProfile(updatedProfile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    // Update controllers when profile data is loaded
    if (profileState.profile != null && !profileState.isLoading) {
      _updateControllers(profileState.profile!);
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          key: const Key('profile_back_button'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          profileState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar perfil',
                        style: theme.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const Key('profile_name_field'),
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('profile_email_field'),
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo electrónico';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('profile_save_button'),
                          onPressed:
                              profileState.isLoading
                                  ? null
                                  : _handleSaveProfile,
                          child:
                              profileState.isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Guardar cambios'),
                        ),
                      ),
                      if (profileState.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            profileState.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
