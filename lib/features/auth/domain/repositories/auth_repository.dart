import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<DomainException, UserEntity>> login(
    String email,
    String password,
  );
  Future<Either<DomainException, UserEntity>> register(
    String email,
    String password,
  );
  Future<void> logout();
  Future<Either<DomainException, UserEntity?>> getCurrentUser();
  Future<bool> isEmailRegistered(String email);
}
