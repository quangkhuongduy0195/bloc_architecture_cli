class WidgetBaseLoadingIndicatorGenerator {
  static String gen() {
    return '''import 'package:skeletonizer/skeletonizer.dart';

import '../../core/common/base/base_bloc.dart';
import '../../core/common/base/base_state.dart';
import '../../core/common/base/mixin/log_mixin.dart';
import '../../core/config.dart';
import '../fetch_more_indicator.dart';

/// A widget that displays a loading indicator when more data needs to be fetched.
///
/// The [BaseLoadingIndicator] listens to the state of a [Bloc] and displays a
/// loading indicator when more data needs to be fetched. It uses a [ScrollController]
/// to detect when the user has scrolled to the bottom of the list and triggers
/// the [onFetchMore] callback to fetch more data.
///
/// The [isLoadingMore] and [hasMore] callbacks are used to determine whether
/// more data is currently being loaded and whether there is more data to load,
/// respectively.
///
/// The [B] type parameter represents the type of the [Bloc] and the [S] type
/// parameter represents the type of the state.
///
/// example:
/// ```dart
/// class UserLoadingIndicator extends BaseLoadingIndicator<UserBloc, UserState> {
/// UserLoadingIndicator({
///     super.key,
///    required super.scrollController,
///  }) : super(
///         onFetchMore: (context) {
///        context.read<UserBloc>().add(const UserEventLoadMoreUsers());
///        },
///    isLoadingMore: (UserState state) {
///  return state is UserStateLoadingMore;
/// },
/// hasMore: (UserState state) {
/// return (state is UserStateLoaded && state.data.hasMore) ||
///    state is UserStateLoadingMore;
///    },
///  );
/// }

/// ```
///
///
///
class BaseLoadingIndicator<B extends BaseBloc<dynamic, S>, S extends BaseState>
    extends StatelessWidget with LogMixin {
  /// Creates a new instance of [BaseLoadingIndicator].
  ///
  /// The [scrollController], [onFetchMore], [isLoadingMore], and [hasMore]
  /// parameters must not be null.
  const BaseLoadingIndicator({
    super.key,
    required this.onFetchMore,
    required this.isLoadingMore,
    required this.hasMore,
    this.child,
  });

  /// The callback to be triggered when more data needs to be fetched.
  final void Function(BuildContext context, S state) onFetchMore;

  /// A callback that returns whether there is more data to load.
  final bool Function(S state) hasMore;

  /// A callback that returns whether more data is currently being loaded.
  final bool Function(S state) isLoadingMore;

  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        if (hasMore(state)) {
          return Skeletonizer(
            enabled: true,
            child: FetchMoreIndicator(
              isLoadingMore: isLoadingMore(state),
              onFetchMore: () {
                onFetchMore(context, state);
              },
              child: child,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
''';
  }
}
