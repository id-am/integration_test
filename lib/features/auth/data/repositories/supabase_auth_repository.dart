import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/auth/data/datasources/auth_data_source.dart';
import 'package:integration_test_lab/features/auth/data/models/user_model.dart';
import 'package:integration_test_lab/features/auth/domain/entities/user_entity.dart';
import 'package:integration_test_lab/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final AuthDataSource _dataSource;

  SupabaseAuthRepository(this._dataSource);

  @override
  Future<Either<DomainException, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final authResponse = await _dataSource.signInWithEmail(email, password);

      return authResponse.when(
        (error) => Left(error),
        (user) => Right(UserModel.fromSupabaseUser(user).toEntity()),
      );
    } catch (e) {
      return Left(LoginException('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DomainException, UserEntity>> register(
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
        (user) => Right(UserModel.fromSupabaseUser(user).toEntity()),
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
  Future<Either<DomainException, UserEntity>> getCurrentUser() async {
    try {
      final authResponse = await _dataSource.getCurrentAuthUser();

      if (authResponse.isLeft) {
        return Left(GetUserException('Failed to get current user'));
      }

      return authResponse.when((error) => Left(error), (user) async {
        return Right(UserModel.fromSupabaseUser(user).toEntity());
      });
    } catch (e) {
      return Left(
        GetUserException('Failed to get current user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<bool> isEmailRegistered(String email) {
    return _dataSource.isEmailRegistered(email);
  }
}
