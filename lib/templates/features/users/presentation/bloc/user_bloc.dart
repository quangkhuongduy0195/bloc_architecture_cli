class UserBlocGenerator {
  static String gen() {
    return '''

import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/common/base/base_bloc.dart';
import '../../../../core/common/base/base_event.dart';
import '../../../../core/common/base/base_state.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/usecases/get_users.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends BaseBloc<UserEvent, UserState> {
  UserBloc({
    required GetUsers getUsers,
  })  : _getUsers = getUsers,
        super(const UserStateInitial()) {
    on<UserEventFetchUsers>((event, emit) async {
      emit(const UserStateLoading());
      await _onFetchUsers(emit);
    });
    on<UserEventRefreshUsers>((event, emit) async {
      emit(const UserStatePullRefresh());
      skip = 0;
      await _onFetchUsers(emit);
      event.completer.complete();
    });

    on<UserEventLoadMoreUsers>((event, emit) async {
      if (hasMore) {
        emit(const UserStateLoadingMore());
        await _onFetchUsers(emit, isLoadMore: true);
      }
    });
  }

  final GetUsers _getUsers;

  int limit = 20;

  int skip = 0;

  bool hasMore = true;

  UserListResponse oldData = UserListResponse.empty();

  Future<void> _onFetchUsers(
    Emitter<UserState> emit, {
    bool isLoadMore = false,
  }) async {
    final result = await _getUsers.call(
      GetUsersParams(limit: limit, skip: skip),
    );
    result.fold(
      (AppException) {
        emit(UserStateError(AppException.message));
      },
      (response) {
        hasMore = response.hasMore;
        skip += limit;
        if (isLoadMore) {
          oldData = oldData.merge(response);
          emit(UserStateLoaded(oldData));
        } else {
          oldData = response;
          emit(UserStateLoaded(response));
        }
      },
    );
  }
}
''';
  }
}
