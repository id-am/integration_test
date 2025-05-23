import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<DomainException, UserModel>> login(
    String email,
    String password,
  );
  Future<Either<DomainException, UserModel>> register(
    String email,
    String password,
  );
  Future<void> logout();
  Future<Either<DomainException, UserModel?>> getCurrentUser();
}
