class AuthCheckGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/authentication_repository.dart';

@Injectable()
class AuthCheck implements UsecaseWithoutFuture<User?> {
  const AuthCheck(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<User?> call() => _repository.authenticated();
}
''';
  }
}
