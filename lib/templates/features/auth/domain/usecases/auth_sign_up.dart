class AuthSignUpGenerator {
  static String gen() {
    return '''import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/authentication_repository.dart';

@injectable
class AuthSignUp extends UsecaseWithParams<User, SignUpParam> {
  AuthSignUp(this._repository);
  final AuthenticationRepository _repository;

  @override
  Future<Either<AppException, User>> call(SignUpParam params) {
    return _repository.signUpWithEmailPassword(
      username: params.username,
      password: params.password,
    );
  }
}

class SignUpParam {
  const SignUpParam({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;
}
''';
  }
}
