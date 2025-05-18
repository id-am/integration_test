import 'package:integration_test_lab/core/utils/either.dart';
import 'package:integration_test_lab/core/domain/exceptions/domain_exceptions.dart';
import 'package:integration_test_lab/features/auth/domain/models/user_model.dart';
import 'package:integration_test_lab/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<DomainException, UserModel>> call(
    String email,
    String password,
  ) async => await repository.register(email, password);
}
