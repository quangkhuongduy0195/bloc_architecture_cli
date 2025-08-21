class StringExtGenerator {
  static String gen() {
    return '''import 'package:intl/intl.dart';

import '../config.dart';

/// Example of using the extension
/// ```dart
/// final String? name = 'hello world';
/// print(name.upperCaseFirst); // Hello world
/// print(name.lowerCaseFirst); // hello world
/// print(name.camelCaseToHyphen); // hello-world
///
/// ```

extension StringExt on String? {
  Locale toLocale() {
    final parts = (this ?? '').split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    }
    return Locale(parts[0], parts[1]);
  }

  String get upperCaseFirst {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return '\${this![0].toUpperCase()}\${this!.substring(1)}';
  }

  String get lowerCaseFirst {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return '\${this![0].toLowerCase()}\${this!.substring(1)}';
  }

  String camelCaseToHyphen() {
    RegExp exp = RegExp(r'(?<=[a-z])(?=[A-Z])');
    return this!.replaceAllMapped(exp, (Match m) => '-').toLowerCase();
  }

  /// ```dart
  /// final String? name = '@admin hello world';
  /// print(name.removeTag); //hello world
  /// final String? name = '@admin ';
  /// print(name.removeTag); //''
  /// ```

  String get removeTag {
    return this?.replaceAll(RegExp(r'^@\w+\s*'), '') ?? '';
  }

  /// ```dart
  /// final String? date = '2024-10-01 08:39:0';
  /// print 03 Oct 09:30
  /// ```
  String get formatDateTime {
    try {
      final date = DateTime.parse(this!);
      return DateFormat('dd MMM HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatDate([Locale? locale]) {
    String? languageCode = locale?.languageCode;
    try {
      if (languageCode == 'jp') {
        languageCode = 'ja';
      }
      final date = DateTime.parse(this!);
      return DateFormat('dd MMM', languageCode).format(date);
    } catch (e) {
      return '';
    }
  }
}

''';
  }
}
