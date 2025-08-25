class WidgetFetchMoreIndicatorGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FetchMoreIndicator extends HookWidget {
  const FetchMoreIndicator({
    super.key,
    this.onFetchMore,
    this.child,
    this.isLoadingMore = false,
  });
  final FutureOr<void> Function()? onFetchMore;
  final Widget? child;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('FetchMoreIndicator'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !isLoadingMore) {
          onFetchMore?.call();
        }
      },
      child: child ?? const SizedBox(),
    );
  }
}
''';
  }
}
