class AuthenticationRepositoryImplGenerator {
  static String gen() {
    return '''import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/network/connection_checker.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  const AuthenticationRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.connectionChecker,
  );

  final AuthRemoteDataSource remoteDataSource;

  final AuthLocalDataSource localDataSource;

  final ConnectionChecker connectionChecker;

  @override
  Future<void> logout() => localDataSource.remove();

  @override
  Future<Either<AppException, User>> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    /// Check if the device is connected to the internet.
    if (!await connectionChecker.isConnected) {
      return Left(NetworkException());
    }
    final result = await remoteDataSource.loginWithUsernamePassword(
      username: username,
      password: password,
    );

    /// Save the token to local storage if the authentication is successful.
    if (result is Right) {
      final user = result.fold(
        (l) => null,
        (r) => r,
      );
      if (user != null) {
        await localDataSource.saveToken(user);
      }
    }
    return result;
  }

  @override
  Future<User?> authenticated() => localDataSource.authentication();

  @override
  Future<Either<AppException, User>> signUpWithEmailPassword({
    required String username,
    required String password,
  }) {
    return remoteDataSource.signUpWithEmailPassword(
      username: username,
      password: password,
    );
  }
}
''';
  }
}
