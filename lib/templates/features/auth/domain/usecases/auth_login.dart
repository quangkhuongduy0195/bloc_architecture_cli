class AuthLoginGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/authentication_repository.dart';

@Injectable()
class AuthLogin extends UsecaseWithParams<User, LoginParam> {
  AuthLogin(this._repository);
  final AuthenticationRepository _repository;

  @override
  Future<Either<AppException, User>> call(LoginParam params) async {
    return _repository.loginWithUsernamePassword(
      username: params.username,
      password: params.password,
    );
  }
}

class LoginParam {
  const LoginParam({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;
}
''';
  }
}
