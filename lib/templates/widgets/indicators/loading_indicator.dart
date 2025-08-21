class WidgetLoadingIndicatorGenerator {
  static String gen() {
    return '''import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.width = 30.0,
    this.color,
    this.isSeparatePlatform = true,
    this.strokeWidth = 3.0,
    this.padding = 10.0,
  });
  final double strokeWidth, padding;
  final double width;
  final Color? color;
  final bool isSeparatePlatform;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SizedBox(
          width: width,
          height: width,
          child: CircularProgressIndicator.adaptive(
            backgroundColor: defaultTargetPlatform == TargetPlatform.iOS
                ? color ?? Theme.of(context).primaryColor
                : null,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor,
            ),
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}
''';
  }
}
