class WidgetRefreshGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that provides pull-to-refresh functionality.
///
/// The [RefreshWidget] wraps a child widget and adds pull-to-refresh
/// functionality using a [RefreshIndicator]. When the user pulls down
/// on the child widget, the [onRefresh] callback is triggered.
///
/// The [isOverScrolling] parameter determines whether the refresh
/// indicator should be triggered when the user scrolls past the edge
/// of the child widget. If [isOverScrolling] is true, the refresh
/// indicator is triggered when the user scrolls past the edge of the
/// child widget. If [isOverScrolling] is false, the refresh indicator
/// is triggered when the user scrolls to the edge of the child widget.
///
/// The [isLayoutBuilder] parameter determines whether the child widget
/// should be wrapped in a [LayoutBuilder]. If [isLayoutBuilder] is true,
/// the child widget is wrapped in a [LayoutBuilder]. If [isLayoutBuilder]
/// is false, the child widget is not wrapped in a [LayoutBuilder].
class RefreshWidget extends StatelessWidget {
  /// Creates a new instance of [RefreshWidget].
  const RefreshWidget({
    super.key,
    required this.child,
    required this.onRefresh,
    this.isOverScrolling = false,
    this.isLayoutBuilder = true,
  });

  /// The child widget to be wrapped by the [RefreshWidget].
  final Widget child;

  /// The callback to be triggered when the user pulls down on the child widget.
  final Function(Completer<void> completer) onRefresh;

  /// Whether the refresh indicator should be triggered when the user scrolls
  /// past the edge of the child widget.
  final bool isOverScrolling;

  /// Whether the child widget should be wrapped in a [LayoutBuilder].
  final bool isLayoutBuilder;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final Completer<void> completer = Completer<void>();
        onRefresh(completer);
        return completer.future;
      },
      notificationPredicate: (ScrollNotification notification) {
        return isOverScrolling
            ? notification.depth == 1
            : notification.depth == 0;
      },
      child: isLayoutBuilder
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: child,
                  ),
                );
              },
            )
          : child,
    );
  }
}
''';
  }
}
