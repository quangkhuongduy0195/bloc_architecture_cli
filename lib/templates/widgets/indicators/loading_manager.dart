class WidgetLoadingManagerGenerator {
  static String gen() {
    return '''import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'loading_indicator.dart';

mixin LoadingManager {
  static OverlayEntry? overlayEntry;
  static void hide() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  static void show(BuildContext context) {
    if (overlayEntry != null) return;

    final OverlayState overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.5),
        child: const LoadingIndicator(color: Colors.white),
      ),
    );
    overlayState.insert(overlayEntry!);
  }
}
''';
  }
}
