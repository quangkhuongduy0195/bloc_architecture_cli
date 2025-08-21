class AuthLogoutGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

@injectable
class AuthLogout extends UsecaseWithoutFuture<void> {
  AuthLogout(this._repository);
  final AuthenticationRepository _repository;

  @override
  Future<void> call() => _repository.logout();
}
''';
  }
}
