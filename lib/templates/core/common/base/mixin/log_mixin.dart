class LogMixinGenerator {
  static String gen() {
    return '''import '../../../config.dart';

mixin LogMixin {
  void log(Object msg, {String tag = Configs.appName}) {
    Logger.log(msg, tag: toString());
  }
}
''';
  }
}
