class WidgetBasePageStateGenerator {
  static String gen() {
    return '''import 'dart:async';

import '../../core/common/base/base_bloc.dart';
import '../../core/common/base/base_state.dart';
import '../../core/common/base/mixin/log_mixin.dart';
import '../../core/config.dart';
import '../indicators/loading_indicator.dart';
import '../refresh_widget.dart';
import 'base_loading_indicator.dart';

/// Enum representing the different states of the view.
enum ViewState { loading, view, error }

/// A base class for page states that provides common functionality for pages
/// that use a [Bloc] for state management.
///
/// The [BasePageState] class extends [BasePageStateDelegate] and provides
/// a common structure for pages that use a [Bloc] for state management.
/// It requires a [StatefulWidget] and a [BaseBloc] as type parameters.
abstract class BasePageState<T extends StatefulWidget, B extends BaseBloc>
    extends BasePageStateDelegate<T, B> {}

/// A delegate class for page states that provides common functionality for
/// pages that use a [Bloc] for state management.
///
/// The [BasePageStateDelegate] class extends [State] and provides a common
/// structure for pages that use a [Bloc] for state management. It requires
/// a [StatefulWidget] and a [BaseBloc] as type parameters.
abstract class BasePageStateDelegate<T extends StatefulWidget,
    B extends BaseBloc> extends State<T> with LogMixin {
  late B bloc;

  @override
  void initState() {
    bloc = createBloc();
    onInit();
    super.initState();
  }

  /// Called during the initialization of the state.
  void onInit();

  /// Creates the [Bloc] instance.
  B createBloc();

  /// Builds the page widget.
  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: buildPage(context),
    );
  }
}

/// A base class for list views that provides common functionality for list
/// views that use a [Bloc] for state management.
///
/// The [BaseListView] class extends [State] and provides a common structure
/// for list views that use a [Bloc] for state management. It requires a
/// [StatefulWidget], a [BaseBloc], and a [BaseState] as type parameters.
abstract class BaseListView<
    DataType,
    T extends StatefulWidget,
    B extends BaseBloc<dynamic, S>,
    S extends BaseState> extends State<T> with LogMixin {
  final _scrollController = ScrollController();

  /// Returns the list of items from the given state.
  List<DataType> items(S state);

  /// Builds the item widget for the given item.
  Widget itemBuilder(BuildContext context, DataType item, int index);

  /// Determines whether the widget should be rebuilt when the state changes.
  bool buildWhen(S previous, S current) {
    return true;
  }

  /// Determines whether there are more items to load.
  bool hasMore(S state) => false;

  /// Determines whether more items are currently being loaded.
  bool isLoadingMore(S state) => false;

  /// Determines whether the list view is over-scrolling.
  bool isOverScrolling(S state) => true;

  /// Called when more items need to be fetched.
  void onFetchMore(BuildContext context, S state);

  /// Called when the list view needs to be refreshed.
  void onRefresh(Completer<void> completer);

  /// Returns the error message for the given state.
  String errorMessage(S state);

  /// Returns the view state for the given state.
  ViewState viewState(S state);

  late B bloc;

  /// Creates the [Bloc] instance.
  B createBloc();

  /// Builds the loading indicator widget.
  Widget loadingIndicator() => const LoadingIndicator();

  /// A delegate class for list views that provides common functionality for list
  Widget loadMoreIndicator() => const LoadingIndicator();

  @override
  void initState() {
    bloc = createBloc();
    onInit();
    super.initState();
  }

  /// Called during the initialization of the state.
  void onInit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder<B, S>(
        buildWhen: buildWhen,
        builder: (context, state) {
          return RefreshWidget(
            onRefresh: onRefresh,
            isOverScrolling: isOverScrolling(state),
            child: switch (viewState(state)) {
              ViewState.loading => loadingIndicator(),
              ViewState.error => Center(
                  child: Text(
                    errorMessage(state),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ViewState.view => ListView.builder(
                  controller: _scrollController,
                  itemCount: items(state).length + 1,
                  itemBuilder: (context, index) {
                    final item = items(state).elementAtOrNull(index);
                    if (item == null) {
                      return BaseLoadingIndicator<B, S>(
                        onFetchMore: onFetchMore,
                        isLoadingMore: isLoadingMore,
                        hasMore: hasMore,
                        child: loadMoreIndicator(),
                      );
                    }
                    return itemBuilder(context, item, index);
                  },
                ),
            },
          );
        },
      ),
    );
  }
}
''';
  }
}
