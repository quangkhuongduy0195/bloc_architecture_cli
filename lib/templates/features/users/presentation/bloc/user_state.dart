class UserStateGenerator {
  static String gen() {
    return '''part of 'user_bloc.dart';

sealed class UserState extends BaseState {
  const UserState();
}

class UserStateInitial extends UserState {
  const UserStateInitial();
}

class UserStateLoading extends UserState {
  const UserStateLoading();
}

class UserStateLoaded extends UserState {
  const UserStateLoaded(this.data);

  final UserListResponse data;

  @override
  List<Object> get props => [data];
}

class UserStateError extends UserState {
  const UserStateError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class UserStatePullRefresh extends UserState {
  const UserStatePullRefresh();
}

class UserStateLoadingMore extends UserState {
  const UserStateLoadingMore();
}
''';
  }
}
