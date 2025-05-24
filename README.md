<h1 align="center">
  <br>
  <a href="http://www.amitmerchant.com/electron-markdownify"><img src="https://f.hubspotusercontent20.net/hubfs/2829524/Copia%20de%20LOGOTIPO_original-2.png"></a>
  <br>
  Laboratorio Integration Testing
  <br>
</h1>

<h4 align="center">Proyecto base de <a href="https://github.com/karatelabs/karate" target="_blank">Pragma</a>.</h4>

<p align="center"> 
  <img alt="Flutter Version" src="https://img.shields.io/badge/Flutter-3.29+-blue.svg">
  <img alt="License" src="https://img.shields.io/badge/License-MIT-green.svg"> 
</p>

Este proyecto es un ejemplo educativo de cómo implementar pruebas de integración en Flutter utilizando el patrón Robot. Está diseñado para ayudar a desarrolladores a entender los conceptos fundamentales de las pruebas de integración, automatización de flujos de usuario y validación del comportamiento de la aplicación completa.

<p align="center">
  <a href="#topicos">Tópicos</a> •
  <a href="#tecnologias">Tecnologías</a> •
  <a href="#consideraciones">Consideraciones</a> •
  <a href="#descarga">Descarga</a> •
  <a href="#instalación-y-ejecución">Instalación y ejecución</a> •
  <a href="#autores">Autores</a> •
  <a href="#relacionados">Relacionados</a> •
  <a href="#roadmap">Roadmap</a>
</p>

## Tópicos
- <a href="#introducción-a-las-pruebas-de-integración">Introducción a las Pruebas de Integración</a>
- <a href="#el-patrón-robot">El Patrón Robot</a>
- <a href="#estructura-del-proyecto">Estructura del Proyecto</a>
- <a href="#organización-de-carpetas">Organización de Carpetas</a>
- <a href="#patrones-de-organización">Patrones de Organización</a>
- <a href="#implementación-del-patrón-robot">Implementación del Patrón Robot</a>
- <a href="#conceptos-de-testing-demostrados">Conceptos de Testing Demostrados</a>
- <a href="#prácticas-demostradas">Prácticas Demostradas</a>
- <a href="#mejores-prácticas-para-pruebas-de-integración">Mejores Prácticas</a>
- <a href="#problemas-comunes-y-soluciones">Problemas Comunes y Soluciones</a>

## Introducción a las Pruebas de Integración
Las pruebas de integración son esenciales para validar que diferentes componentes de una aplicación funcionan correctamente juntos. A diferencia de las pruebas unitarias que se enfocan en componentes aislados, las pruebas de integración verifican flujos completos que atraviesan múltiples partes de la aplicación. Este proyecto demuestra cómo implementar pruebas de integración en Flutter, simulando interacciones reales del usuario y verificando el comportamiento correcto de la aplicación desde el inicio de sesión hasta la navegación entre pantallas.

## El Patrón Robot
Este proyecto implementa el patrón Robot para pruebas de integración, que proporciona una forma estructurada y mantenible de escribir pruebas de extremo a extremo:

- **Robot**: Clase que encapsula las interacciones con la interfaz de usuario
- **Page Object**: Representación de una pantalla o componente de la UI
- **Test Case**: Escenario de prueba que utiliza robots para interactuar con la aplicación

El patrón Robot ayuda a:
- **Mejorar la legibilidad**: Los métodos describen acciones de usuario ("login", "verificarPantalla")
- **Facilitar el mantenimiento**: Si cambia la UI, solo se actualiza el robot correspondiente
- **Reutilizar código**: Los robots pueden ser utilizados en múltiples pruebas
- **Separar responsabilidades**: Las pruebas se centran en "qué" probar, mientras que los robots en "cómo" hacerlo

## Estructura del Proyecto

El proyecto contiene los siguientes componentes principales:

1. **Robots**: Clases que encapsulan las interacciones con la interfaz de usuario, siguiendo el patrón Robot.
2. **Test Setup**: Configuración inicial para las pruebas de integración, incluyendo inicialización y reinicio.
3. **Test Helpers**: Funciones auxiliares para facilitar las pruebas.
4. **Flujos de Prueba**: Pruebas de flujos completos como autenticación y registro.
5. **Constantes de Testing**: Claves y valores utilizados en las pruebas para identificar widgets.

### Organización de Carpetas

```
integration_test_lab/
├── lib/                                    # Código fuente principal
│   ├── main.dart                           # Punto de entrada de la aplicación
│   ├── core/                               # Funcionalidades centrales
│   │   └── consts/
│   │       └── app_widget_keys.dart        # Claves para identificar widgets en pruebas
│   └── features/                           # Funcionalidades de la aplicación
│       ├── auth/                           # Autenticación
│       └── home/                           # Pantalla principal
│
├── integration_test/                       # Pruebas de integración
│   ├── integration_test.dart               # Configuración principal de pruebas de integración
│   ├── auth_flow_test.dart                 # Pruebas del flujo de autenticación
│   ├── register_flow_test.dart             # Pruebas del flujo de registro
│   ├── test_setup.dart                     # Configuración común para pruebas
│   ├── robots/                             # Robots para interacción con UI
│   │   ├── base_robot.dart                 # Robot base
│   │   ├── login_robot.dart                # Robot para pantalla de login
│   │   └── register_robot.dart             # Robot para pantalla de registro
│   └── test_helpers/                       # Funciones auxiliares para pruebas
│
├── pubspec.yaml                            # Dependencias y configuración del proyecto
└── README.md                               # Documentación del proyecto
```

### Patrones de Organización

#### 1. Estructura por Responsabilidad en Pruebas

```
Test Setup -> Robots -> Test Cases
```

**Ventajas:**
- Facilita la escritura y mantenimiento de pruebas de integración
- Mejora la legibilidad y organización del código
- Permite la reutilización de componentes entre diferentes pruebas

#### 2. Patrón Robot

```
BaseRobot -> SpecificRobots (LoginRobot, RegisterRobot) -> Test Cases
```

**Ventajas:**
- Encapsula la interacción con la UI
- Separa "qué probar" de "cómo probar"
- Facilita el mantenimiento cuando cambia la interfaz de usuario

## Conceptos de Testing Demostrados

### 1. Pruebas End-to-End
- Verificación de flujos completos de usuario
- Validación del comportamiento integrado de la aplicación
- Simulación de interacciones reales del usuario con la aplicación

### 2. Patrón Robot
- Implementación de robots especializados por pantalla
- Encapsulamiento de operaciones de UI en métodos descriptivos
- Herencia para compartir comportamientos comunes (BaseRobot)

### 3. Aserciones en UI
- Verificación de elementos visibles: `expect(find.byKey(key), findsOneWidget)`
- Verificación de navegación: `expect(find.byKey(AppWidgetKeys.homeScreen), findsOneWidget)`
- Verificación de estados de UI: `expect(find.text('Mensaje de error'), findsNothing)`

### 4. Setup y Teardown de Estado
- Inicialización del entorno antes de cada prueba 
- Limpieza del estado después de las pruebas
- Reutilización de código de inicialización

## Prácticas Demostradas

1. **Organización de Tests de Integración**
   - Uso de `group` para agrupar flujos de prueba relacionados
   - Nombres descriptivos que representan escenarios de usuario
   - Uso de `setUpAll` y `tearDownAll` para configuración global

2. **Patrón Robot**
   - Abstracción de las interacciones con la UI
   - Métodos intuitivos que reflejan acciones del usuario
   - Robots especializados para diferentes secciones de la aplicación

3. **Patrón AAA (Arrange-Act-Assert)**
   - Preparación del entorno y la aplicación (arrange)
   - Ejecución de acciones del usuario mediante robots (act)
   - Verificación del estado final de la UI (assert)

4. **Pruebas Estables y Reproducibles**
   - Manejo de esperas y sincronización con `pumpAndSettle()`
   - Uso de claves de widget para identificación robusta
   - Aislamiento de pruebas para evitar dependencias entre ellas
   
5. **Flujos Completos de Usuario**
   - Pruebas de flujos de autenticación completos
   - Verificación de navegación entre pantallas
   - Validación del estado de la aplicación después de acciones del usuario

## Mejores Prácticas para Pruebas de Integración

### 1. Identificación Robusta de Widgets

Utiliza claves (`Key`) para identificar widgets de forma consistente:

```dart
// En el código de la aplicación
ElevatedButton(
  key: AppWidgetKeys.loginButton,
  onPressed: () => login(),
  child: Text('Login'),
)

// En las pruebas
await tester.tap(find.byKey(AppWidgetKeys.loginButton));
```

### 2. Manejo de la Asincronía

Las operaciones asíncronas son comunes en aplicaciones Flutter. Usa `pumpAndSettle()` para esperar a que se completen las animaciones y tareas asíncronas:

```dart
await tester.tap(find.byKey(AppWidgetKeys.loginButton));
await tester.pumpAndSettle(); // Espera a que se completen las animaciones y la navegación
```

### 3. Organización de Pruebas

Agrupa pruebas relacionadas para mayor claridad:

```dart
group('Flujo de Autenticación', () {
  testWidgets('Login exitoso', (WidgetTester tester) async {
    // Código de prueba
  });

  testWidgets('Login fallido', (WidgetTester tester) async {
    // Código de prueba
  });
});
```

### 4. Datos de Prueba Consistentes

Utiliza datos de prueba conocidos y controlados.

```dart
// Usando una función auxiliar para crear datos de prueba
UserCredentials getTestCredentials() {
  return UserCredentials(
    email: 'test@example.com', 
    password: 'password123'
  );
}
```

### 5. Reinicio de Estado

Intentar que cada prueba comience con un estado limpio y predecible:

```dart
setUp(() async {
  // Reiniciar el estado antes de cada prueba
  await IntegrationTestSetup.resetAppState();
});
```

### 6. Pruebas Independientes

Cada prueba debe ser independiente y no depender de los resultados de otras pruebas:

```dart
// Incorrecto: Dependencia entre pruebas
testWidgets('Test A', (tester) async {
  // Hacer algo que afecta al estado global
});

testWidgets('Test B depende de A', (tester) async {
  // Depende del estado modificado por Test A
});

// Correcto: Pruebas independientes
testWidgets('Test A', (tester) async {
  await IntegrationTestSetup.pumpApp(tester);
  // Configuración específica para este test
  // Ejecutar prueba
});

testWidgets('Test B', (tester) async {
  await IntegrationTestSetup.pumpApp(tester);
  // Configuración específica para este test
  // Ejecutar prueba
});
```

## Implementación del Patrón Robot

El patrón Robot es una metodología específica para organizar pruebas de integración que mejora la legibilidad, mantenibilidad y escalabilidad de las pruebas automatizadas. En este proyecto, los robots sirven como una capa de abstracción entre las pruebas y la interfaz de usuario.

### Estructura de Robots

```
BaseRobot
  ├── LoginRobot
  └── RegisterRobot
```

### Componentes Clave

#### BaseRobot
```dart
abstract class BaseRobot {
  final WidgetTester tester;

  BaseRobot(this.tester);
}
```

La clase `BaseRobot` proporciona la funcionalidad común a todos los robots, como mantener una referencia al `WidgetTester` para realizar acciones sobre la interfaz.

#### Robots Específicos

Los robots específicos extienden el `BaseRobot` y añaden métodos que representan acciones concretas que un usuario puede hacer en una pantalla determinada.

```dart
class LoginRobot extends BaseRobot {
  LoginRobot(super.tester);

  Future<void> enterCredentials({
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await tester.enterText(find.byKey(AppWidgetKeys.loginEmailField), email);
    await tester.enterText(find.byKey(AppWidgetKeys.loginPasswordField), password);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginButton() async {
    await tester.tap(find.byKey(AppWidgetKeys.loginButton));
    await tester.pumpAndSettle();
  }

  Future<void> performLogin({
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await enterCredentials(email: email, password: password);
    await tapLoginButton();
  }
}
```

### Ventajas en la Práctica

1. **Código Expresivo**: Los métodos de los robots describen claramente las acciones que realiza un usuario.

2. **Flujos Complejos**: Facilita la creación de flujos complejos combinando métodos simples:
   ```dart
   // En un test:
   final loginRobot = LoginRobot(tester);
   await loginRobot.performLogin();
   ```

3. **Adaptabilidad**: Si cambia la implementación de la UI (como cambiar una clave de widget), solo se necesita actualizar el robot correspondiente, no todas las pruebas.

4. **Legibilidad**: Las pruebas se vuelven más legibles, centrándose en "qué" se está probando en lugar de "cómo" se interactúa con la UI:
   ```dart
   testWidgets('Login exitoso y navegación a Home', (WidgetTester tester) async {
     await IntegrationTestSetup.pumpApp(tester);
     final loginRobot = LoginRobot(tester);
     await loginRobot.performLogin();
     expect(find.byKey(AppWidgetKeys.homeScreen), findsOneWidget);
   });
   ```

## Tecnologías
- [Flutter](https://flutter.dev/) versión 3.7 - Framework de desarrollo de aplicaciones multiplataforma
- [Dart](https://dart.dev/) - Lenguaje de programación utilizado por Flutter
- [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) - Gestión de estado
- [Supabase Flutter](https://pub.dev/packages/supabase_flutter) - Backend as a Service para autenticación y datos
- [Integration Test](https://docs.flutter.dev/testing/integration-tests) - Paquete oficial para pruebas de integración
- [Flutter Driver](https://api.flutter.dev/flutter/flutter_driver/) - Framework para pruebas de instrumentación

## Consideraciones
- Asegúrate de tener Flutter instalado y configurado en tu máquina.
- Para ejecutar pruebas de integración necesitarás un emulador o dispositivo físico conectado.
- El proyecto utiliza Supabase para autenticación, asegúrate de configurar las credenciales correctamente.
- Las pruebas de integración pueden tardar más tiempo en ejecutarse que las pruebas unitarias.
- Este proyecto está diseñado para ser educativo y demostrar buenas prácticas de Integration Testing.

## Descarga

Para clonar esta aplicación desde la línea de comando:

```bash
git clone https://github.com/id-am/integration_test_lab.git
cd integration_test_lab
```

## Configuración del entorno

La aplicación puede ejecutarse en diferentes entornos utilizando la clase CurrentEnvironment:

```dart
// Configurar el entorno en modo mock para pruebas
CurrentEnvironment.setEnvironment(EnvironmentEnum.mock);

// Usar entorno de desarrollo (predeterminado)
CurrentEnvironment.setEnvironment(EnvironmentEnum.development);
```

## Configuración de Supabase
También puedes crear tu propia cuenta en Supabase y actualizar las credenciales en `SupabaseConfig`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'TU_URL_DE_SUPABASE';
  static const String supabaseAnonKey = 'TU_CLAVE_ANON_DE_SUPABASE';
}
```

### Crea la tabla de perfiles en Supabase

```sql
-- Crear tabla de perfiles
CREATE TABLE profiles (
    user_id uuid not null,
    name text not null,
    email text not null unique,
    created_at timestamp with time zone default current_timestamp,
    updated_at timestamp with time zone default current_timestamp
);

-- Habilitar RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Crear un índice en user_id para mejorar el rendimiento de las consultas
CREATE INDEX idx_profiles_user_id ON profiles (user_id);
```

### Crea políticas de seguridad en Supabase

```sql
-- Política para permitir a los usuarios autenticados actualizar sus propios registros
CREATE POLICY "Authenticated users can update their own records" 
ON profiles 
FOR UPDATE 
TO authenticated 
USING ((SELECT auth.uid() AS uid) = user_id) 
WITH CHECK (true);

-- Política para permitir la inserción para todos los usuarios basada en user_id
CREATE POLICY "Enable insert for users based on user_id" 
ON profiles 
FOR INSERT 
TO public 
WITH CHECK (true);

-- Política para permitir el acceso de lectura para todos los usuarios
CREATE POLICY "Enable read access for all users" 
ON profiles 
FOR SELECT 
TO public 
USING (true);
```



## Instalación y ejecución

Es necesario contar con Flutter instalado y configurado en tu máquina. Puedes seguir la guía de instalación oficial de Flutter [aquí](https://flutter.dev/docs/get-started/install).

```bash
# Descargar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run

# Ejecutar todas las pruebas de integración (requiere un dispositivo conectado o emulador)
flutter test integration_test/integration_test.dart

# Ejecutar pruebas específicas de integración
flutter test integration_test/auth_flow_test.dart

# Ejecutar las pruebas de integración en un dispositivo específico (si hay múltiples conectados)
flutter test integration_test/integration_test.dart -d <device_id>
```
## Problemas Comunes y Soluciones

### 1. Pruebas Inestables (Flaky Tests)

**Problema**: Pruebas que a veces pasan y a veces fallan sin cambios en el código.

**Soluciones**:
- Usa `pumpAndSettle()` con tiempo suficiente para esperar operaciones asíncronas
- Evita depender de temporizadores exactos
- Verifica que los selectores (finders) sean específicos y únicos

```dart
// En lugar de:
await tester.pump(Duration(seconds: 2));

// Mejor usar:
await tester.pumpAndSettle();
```

### 2. Errores de Sincronización

**Problema**: Los elementos no están disponibles cuando intentas interactuar con ellos.

**Solución**: Espera a que los widgets estén completamente cargados:

```dart
// Espera hasta que un widget específico sea visible
await tester.pumpUntil(
  find.byKey(AppWidgetKeys.specificWidget),
  timeout: Duration(seconds: 5),
);
```

### 3. Problemas con Animaciones

**Problema**: Las animaciones interfieren con las pruebas.

**Solución**: Deshabilita las animaciones durante las pruebas:

```dart
// En test_setup.dart
static Future<void> initialize() async {
  // Deshabilitar animaciones para pruebas
  await tester.binding.setSurfaceSize(Size(1080, 1920));
  tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
  tester.binding.window.devicePixelRatioTestValue = 1.0;
  
  // Configura timeDilation para hacer las animaciones instantáneas
  timeDilation = 0.1;
}
```

### 4. Problemas con Servicios Externos

**Problema**: Las pruebas dependen de servicios externos como APIs o bases de datos.

**Solución**: Usa mocks o entornos de prueba aislados:

```dart
// Configurar un entorno de prueba para Supabase
final supabaseMock = MockSupabaseClient();
when(supabaseMock.auth.signInWithPassword(
  email: anyNamed('email'), 
  password: anyNamed('password'),
)).thenAnswer((_) async => MockAuthResponse());

// Inyectar el mock en la aplicación
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      supabaseClientProvider.overrideWithValue(supabaseMock),
    ],
    child: MyApp(),
  ),
);
```

### 5. Problemas de Rendimiento

**Problema**: Las pruebas de integración son lentas.

**Soluciones**:
- Enfócate en flujos críticos de usuario
- Ejecuta tests en paralelo cuando sea posible
- Usa la configuración de timeouts adecuada en CI/CD
- Considera usar pruebas unitarias para lógica compleja en lugar de probar todo con pruebas de integración

## Autores

[<img src="https://github.com/idamkiller.png" width=115><br><sub>Ivan Dario Avila Martinez</sub>](https://github.com/idamkiller)


## Relacionados
- [Documentación oficial de Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Implementación del Patrón Robot en Flutter](https://rizumita.medium.com/explanation-of-the-robot-pattern-ui-testing-library-in-flutter-e80c402bed7b)
- [Flutter Driver API](https://api.flutter.dev/flutter/flutter_driver/)
- [Flutter Testing Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Supabase](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)

## Roadmap
- Unit Testing → Complejidad baja, pruebas de funciones individuales y lógica de negocio (Completado).
- Widget Testing → Complejidad media, pruebas de widgets individuales (En progreso).
- Integration Testing → Complejidad alta, pruebas de la aplicación completa (Este proyecto).