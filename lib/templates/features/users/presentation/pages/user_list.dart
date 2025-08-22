class UserListGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/config.dart';
import '../../../../di/injection.dart';
import '../../../../widgets/cache_image.dart';
import '../../../../widgets/common/base_page_state.dart';
import '../../../auth/data/models/user_model.dart';
import '../bloc/user_bloc.dart';

class UserListWidget extends StatefulHookWidget {
  const UserListWidget({super.key});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState
    extends BaseListView<User, UserListWidget, UserBloc, UserState> {
  @override
  void onInit() {
    bloc.add(const UserEventFetchUsers());
  }

  @override
  UserBloc createBloc() => UserBloc(getUsers: getIt());

  @override
  String errorMessage(UserState state) {
    if (state is UserStateError) {
      return state.message;
    }
    return '';
  }

  @override
  bool hasMore(UserState state) {
    return (state is UserStateLoaded && state.data.hasMore) ||
        state is UserStateLoadingMore;
  }

  @override
  bool isLoadingMore(UserState state) {
    return state is UserStateLoadingMore;
  }

  @override
  bool isOverScrolling(UserState state) {
    return state is UserStateLoaded && state.data.users.isNotEmpty;
  }

  @override
  Widget loadingIndicator() {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return const UserWidget(user: Fake.user);
        },
      ),
    );
  }

  @override
  Widget loadMoreIndicator() {
    return const UserWidget(user: Fake.user);
  }

  @override
  Widget itemBuilder(BuildContext context, User item, int index) {
    return UserWidget(user: item);
  }

  @override
  void onFetchMore(BuildContext context, UserState state) {
    if (state is UserStateLoaded && state.data.hasMore) {
      context.read<UserBloc>().add(const UserEventLoadMoreUsers());
    }
  }

  @override
  void onRefresh(Completer<void> completer) {
    bloc.add(UserEventRefreshUsers(completer));
  }

  @override
  bool buildWhen(UserState previous, UserState current) {
    return current is UserStateLoaded ||
        current is UserStateError ||
        current is UserStateLoading;
  }

  @override
  List<User> items(UserState state) {
    if (state is UserStateLoaded) {
      return state.data.users;
    }
    return [];
  }

  @override
  ViewState viewState(UserState state) {
    return switch (state) {
      UserStateLoading _ => ViewState.loading,
      UserStateError _ => ViewState.error,
      UserStateLoaded _ => ViewState.view,
      _ => ViewState.loading,
    };
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(user.id),
      leading: CacheImage(
        imageUrl: user.image ?? '',
        width: 40,
        height: 40,
        radius: 100,
      ),
      title: TextApp(
        user.name,
        type: TextType.lg,
        fontWeight: FontWeight.w500,
      ),
      subtitle: TextApp(
        user.email ?? '',
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

''';
  }
}
