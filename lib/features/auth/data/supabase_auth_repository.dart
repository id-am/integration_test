import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/features/auth/domain/datasources/auth_data_source.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/auth/domain/repositories/auth_repository.dart';
import 'package:integration_test_lab/features/auth/domain/models/user_model.dart';

class SupabaseAuthRepository implements AuthRepository {
  final AuthDataSource _dataSource;

  SupabaseAuthRepository(this._dataSource);

  @override
  Future<Either<DomainException, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final authResponse = await _dataSource.signInWithEmail(email, password);

      return authResponse.when(
        (error) => Left(error),
        (user) => Right(UserModel(id: user.id, email: user.email!)),
      );
    } catch (e) {
      return Left(LoginException('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DomainException, UserModel>> register(
    String email,
    String password,
  ) async {
    try {
      final bool isRegistered = await _dataSource.isEmailRegistered(email);

      if (isRegistered) {
        return Left(
          EmailAlreadyRegisteredException(
            'El correo ya está registrado. Por favor, inicia sesión.',
          ),
        );
      }

      final authResponse = await _dataSource.signUpWithEmail(email, password);

      return authResponse.when(
        (error) => Left(error),
        (user) => Right(UserModel(id: user.id, email: user.email!)),
      );
    } catch (e) {
      return Left(RegisterException('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<void> logout() async {
    await _dataSource.signOut();
  }

  @override
  Future<Either<DomainException, UserModel>> getCurrentUser() async {
    try {
      final authResponse = await _dataSource.getCurrentAuthUser();

      if (authResponse.isLeft) {
        return Left(GetUserException('Failed to get current user'));
      }

      return authResponse.when((error) => Left(error), (user) async {
        return Right(UserModel(id: user.id, email: user.email!));
      });
    } catch (e) {
      return Left(
        GetUserException('Failed to get current user: ${e.toString()}'),
      );
    }
  }
}
