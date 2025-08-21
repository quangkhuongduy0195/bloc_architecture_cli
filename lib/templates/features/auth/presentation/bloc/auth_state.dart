class AuthStateGenerator {
  static String gen() {
    return '''
part of 'auth_bloc.dart';

sealed class AuthState extends BaseState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final User user;
  @override
  List<Object> get props => [user];
}

final class AuthAppException extends AuthState {
  const AuthAppException(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
''';
  }
}
