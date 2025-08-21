class l10nExceptionsGenerator {
  /// Generates the code for the [Exceptions] class.
  static String gen() {
    return '''
class LocalizationNotFoundException implements Exception {
  const LocalizationNotFoundException();

  @override
  String toString() => 'Localization not found for current context';
}
''';
  }
}
