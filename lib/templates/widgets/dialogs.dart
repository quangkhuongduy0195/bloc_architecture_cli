class WidgetDialogsGenerator {
  static String gen() {
    return '''library dialogs;

import '../core/config.dart';

class AppDialog {
  AppDialog._();

  static Future<T?> showAppBottomSheet<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    bool barrierDismissible = true,
    String? name,
  }) {
    return showModalBottomSheet(
      context: context,
      routeSettings: RouteSettings(name: name),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      isScrollControlled: true,
      isDismissible: barrierDismissible,
      constraints: BoxConstraints(
        maxHeight: context.screenHeight * 0.8,
      ),
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: context.screenPadding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close_sharp),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                child: Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0.h,
                  horizontal: 20.0.w,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }
}
