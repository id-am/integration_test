/// Representa un valor que puede ser de dos tipos diferentes: [L] o [R].
///
/// La clase Either es comúnmente utilizada para manejar errores de
/// forma funcional,
/// donde [L] representa un error y [R] representa un valor exitoso.
///
/// Ejemplo de uso:
/// ```dart
/// Either<String, int> divide(int a, int b) {
///   if (b == 0) {
///     return Left('División por cero');
///   } else {
///     return Right(a ~/ b);
///   }
/// }
///
/// void main() {
///   final result = divide(10, 2);
///
///   // Usando when para manejar ambos casos
///   final message = result.when(
///     (error) => 'Error: $error',
///     (value) => 'Resultado: $value',
///   );
///
///   // Usando getters directamente
///   if (!result.isLeft) {
///     final value = result.rightOrThrow;
///     print('El resultado es: $value');
///   }
/// }
/// ```
class Either<L, R> {
  /// Constructor privado. Se debe usar [Left] o [Right] para crear instancias.
  const Either._({required L? left, required R? right, required this.isLeft})
    : _left = left,
      _right = right;

  /// Valor de tipo [L], disponible cuando [isLeft] es `true`.
  final L? _left;

  /// Valor de tipo [R], disponible cuando [isLeft] es `false`.
  final R? _right;

  /// Indica si este objeto es de tipo [Left].
  ///
  /// Si es `true`, contiene un valor de tipo [L].
  /// Si es `false`, contiene un valor de tipo [R].
  final bool isLeft;

  /// Obtiene el valor de tipo [L] (Left).
  ///
  /// Lanza una excepción si este objeto es de tipo [Right].
  /// Usar solo cuando se está seguro de que [isLeft] es `true`.
  L get leftOrThrow {
    if (!isLeft) {
      throw Exception('Cannot get left value from Right');
    }
    return _left as L;
  }

  /// Obtiene el valor de tipo [R] (Right).
  ///
  /// Lanza una excepción si este objeto es de tipo [Left].
  /// Usar solo cuando se está seguro de que [isLeft] es `false`.
  R get rightOrThrow {
    if (isLeft) {
      throw Exception('Cannot get right value from Left');
    }
    return _right as R;
  }

  /// Obtiene el valor de tipo [R] si es [Right], o `null` si es [Left].
  ///
  /// Este getter es seguro y no lanza excepciones.
  R? get rightOrNull => isLeft ? null : _right as R;

  /// Transforma este objeto en un valor de tipo [T],
  /// dependiendo de si es [Left] o [Right].
  ///
  /// Proporciona una forma elegante de manejar
  /// ambos casos en una sola expresión.
  ///
  /// @param left Función que transforma el valor de
  /// tipo [L] en [T] si este objeto es [Left].
  /// @param right Función que transforma el valor de
  /// tipo [R] en [T] si este objeto es [Right].
  /// @return Un valor de tipo [T].
  T when<T>(T Function(L) left, T Function(R) right) {
    if (isLeft) {
      return left(_left as L);
    } else {
      return right(_right as R);
    }
  }

  /// Obtiene el valor de tipo [R] si es [Right],
  /// o el [defaultValue] proporcionado si es [Left].
  ///
  /// @param defaultValue El valor por defecto a devolver
  /// si este objeto es [Left].
  /// @return El valor de tipo [R] o el valor por defecto.
  R rightOr(R defaultValue) {
    return isLeft ? defaultValue : _right as R;
  }
}

/// Representa el caso "izquierdo" de [Either],
/// comúnmente usado para representar errores.
class Left<L, R> extends Either<L, R> {
  /// Crea una instancia de [Left] con el valor proporcionado.
  ///
  /// @param value El valor de tipo [L] a almacenar.
  const Left(L value) : super._(left: value, right: null, isLeft: true);
}

/// Representa el caso "derecho" de [Either],
/// comúnmente usado para representar resultados exitosos.
class Right<L, R> extends Either<L, R> {
  /// Crea una instancia de [Right] con el valor proporcionado.
  ///
  /// @param value El valor de tipo [R] a almacenar.
  const Right(R value) : super._(left: null, right: value, isLeft: false);
}
