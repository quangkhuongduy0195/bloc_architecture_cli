class AuthEventGenerator {
  static String gen() {
    return '''
part of 'auth_bloc.dart';

sealed class AuthEvent extends BaseEvent {
  const AuthEvent();
}

final class AuthUserSignUp extends AuthEvent {
  const AuthUserSignUp({
    required this.email,
    required this.password,
    required this.name,
  });
  final String email;
  final String password;
  final String name;
}

final class AuthUserLoggedIn extends AuthEvent {
  const AuthUserLoggedIn({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;
}

final class AuthUserSignedUp extends AuthEvent {
  const AuthUserSignedUp({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;
}

final class AuthIsUserLoggedIn extends AuthEvent {
  const AuthIsUserLoggedIn();
}

final class AuthUserLoggedOut extends AuthEvent {
  const AuthUserLoggedOut();
}
''';
  }
}
