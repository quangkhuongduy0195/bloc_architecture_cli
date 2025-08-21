class AppUserStateGenerator {
  static String gen() {
    return '''part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  const AppUserState({this.user});
  final User? user;
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  const AppUserLoggedIn(User user) : super(user: user);
}

''';
  }
}
