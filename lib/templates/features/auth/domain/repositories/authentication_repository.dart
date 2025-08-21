class AuthenticationRepositoryGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../data/models/user_model.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  Future<Either<AppException, User>> signUpWithEmailPassword({
    required String username,
    required String password,
  });

  Future<Either<AppException, User>> loginWithUsernamePassword({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<User?> authenticated();
}
''';
  }
}
