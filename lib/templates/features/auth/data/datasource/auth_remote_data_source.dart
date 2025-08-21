class AuthRemoteDataSourceGenerator {
  static String gen() {
    return '''import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/base/mixin/api_error_handler_mixin.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/services/auth_service.dart';
import '../models/user_model.dart';

const kCreateUserEndpoint = '/users';
const kGetUsersEndpoint = '/users';
const kLoginEndpoint = '/auth/login';

@Injectable()
class AuthRemoteDataSource with ApiHandlerMixin {
  AuthRemoteDataSource(this.authService);

  final AuthService authService;

  Future<Either<AppException, User>> loginWithUsernamePassword({
    required String username,
    required String password,
  }) {
    final data = {
      'username': username,
      'password': password,
    };
    return request(authService.loginUser(data));
  }

  Future<Either<AppException, User>> signUpWithEmailPassword({
    required String username,
    required String password,
  }) {
    return request(
      authService.registerUser(
        {
          'username': username,
          'password': password,
        },
      ),
    );
  }
}
''';
  }
}
