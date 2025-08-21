class LoggerGenerator {
  /// Generates the code for the logger.
  static String gen() {
    return '''

import 'dart:convert';
import 'dart:developer' as dev;

import '../config.dart';

class Logger {
  Logger._();
  static void log(Object msg, {String tag = Configs.appName}) {
    try {
      dev.log(jsonEncode(msg), name: tag);
    } catch (e) {
      dev.log('\$msg', name: tag);
    }
  }
}

class MyObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    Logger.log('New route pushed: \${route.settings.name}', tag: 'Route Change');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    Logger.log('Tab route re-visited: \${route.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    Logger.log('Tab route visited: \${route.name}', tag: 'Route Change');
    super.didInitTabRoute(route, previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    Logger.log('Tab route re-visited: \${route.name}');
    super.didChangeTabRoute(route, previousRoute);
  }
}
''';
  }
}
