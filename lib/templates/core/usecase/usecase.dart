class UsecaseGenerator {
  /// Generates the code for use cases.
  static String gen() {
    return '''

import 'package:dartz/dartz.dart';

import '../errors/exception.dart';

/// Abstract class for use cases with parameters.
///
/// This class defines the basic structure for use cases that require parameters.
/// It provides a `call` method that takes the parameters and returns a `ResultFuture` object.
///
/// **Example:**
/// ```dart
/// class MyUsecase extends UsecaseWithParams<String, int> {
///   @override
///   ResultFuture<String> call(int params) {
///     return ResultFuture.success('The parameter is \$params');
///   }
/// }
/// ```
abstract class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();
  Future<Either<AppException, Type>> call(Params params);
}

/// Abstract class for use cases without parameters.
///
/// This class defines the basic structure for use cases that do not require parameters.
/// It provides a `call` method that returns a `ResultFuture` object.
///
/// **Example:**
/// ```dart
/// class MyUsecase extends UsecaseWithoutParams<String> {
///   @override
///   ResultFuture<String> call() {
///     return ResultFuture.success('No parameters were provided');
///   }
/// }
/// ```
abstract class UsecaseWithoutParams<Type> {
  const UsecaseWithoutParams();
  Future<Either<AppException, Type>> call();
}

/// Abstract class for use cases with parameters that return a Future.
///
/// This class defines the basic structure for use cases that require parameters and return a Future.
/// It provides a `call` method that takes the parameters and returns a Future object.
///
/// **Example:**
/// ```dart
/// class MyUsecase extends UsecaseWithFuture<String, int> {
///   @override
///   Future<String> call(int params) async {
///     return 'The parameter is \$params';
///   }
/// }
/// ```
abstract class UsecaseWithFuture<Type, Params> {
  const UsecaseWithFuture();
  Future<Type> call(Params params);
}

/// Abstract class for use cases without parameters that return a Future.
///
/// This class defines the basic structure for use cases that do not require parameters and return a Future.
/// It provides a `call` method that returns a Future object.
///
/// **Example:**
/// ```dart
/// class MyUsecase extends UsecaseWithoutFuture<String> {
///   @override
///   Future<String> call() async {
///     return 'No parameters were provided';
///   }
/// }
/// ```
abstract class UsecaseWithoutFuture<Type> {
  const UsecaseWithoutFuture();
  Future<Type> call();
}
''';
  }
}
