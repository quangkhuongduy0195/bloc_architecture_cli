class AuthLocalDataSourceGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/common/base/mixin/persisted_mixin.dart';
import '../models/user_model.dart';

@Injectable()
class AuthLocalDataSource with PersistedStateMixin<User> {
  const AuthLocalDataSource();

  Future<User?> authentication() => load();

  Future<void> saveToken(User user) => save(user.toJson());

  Future<void> unauthenticated() => remove();

  @override
  String get cacheKey => 'ff_authentications_state';

  @override
  FutureOr<User> fromJson(Map<String, dynamic> json) => User.fromJson(json);
}

''';
  }
}
