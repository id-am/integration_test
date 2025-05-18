/// Excepción base para errores de autenticación
abstract class DomainException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  DomainException(this.message, {this.stackTrace});

  @override
  String toString() => message + (stackTrace != null ? '\n$stackTrace' : '');
}

/// Excepción para cuando un email ya está registrado
class EmailAlreadyRegisteredException extends DomainException {
  EmailAlreadyRegisteredException(super.message);
}

/// Excepción cuando falla el login
class LoginException extends DomainException {
  LoginException(super.message);
}

/// Excepción cuando falla el registro
class RegisterException extends DomainException {
  RegisterException(super.message);
}

/// Excepción para errores de logout
class LogoutException extends DomainException {
  LogoutException(super.message);
}

/// Excepción para errores de obtención de usuario
class GetUserException extends DomainException {
  GetUserException(super.message);
}

/// Excepción para errores de creación de perfil
class CreateProfileException extends DomainException {
  CreateProfileException(super.message);
}

/// Excepción para errores de obtención de perfil
class GetProfileException extends DomainException {
  GetProfileException(super.message);
}

/// Excepción para errores de actualización de perfil
class UpdateProfileException extends DomainException {
  UpdateProfileException(super.message);
}

/// Excepción para errores de eliminación de perfil
class DeleteProfileException extends DomainException {
  DeleteProfileException(super.message);
}
