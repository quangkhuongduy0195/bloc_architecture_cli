class UserEventGenerator {
  static String gen() {
    return '''

part of 'user_bloc.dart';

sealed class UserEvent extends BaseEvent {
  const UserEvent();
}

class UserEventFetchUsers extends UserEvent {
  const UserEventFetchUsers();
}

class UserEventLoadMoreUsers extends UserEvent {
  const UserEventLoadMoreUsers();
}

class UserEventRefreshUsers extends UserEvent {
  const UserEventRefreshUsers(this.completer);
  final Completer<void> completer;
}
''';
  }
}
