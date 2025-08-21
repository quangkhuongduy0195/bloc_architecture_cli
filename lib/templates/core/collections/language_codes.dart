class LanguageCodesGenerator {
  static String gen() {
    return '''import 'dart:ui';

import 'locale_keys.g.dart';

class LanguageName {
  const LanguageName({
    required this.name,
    required this.countryCode,
  });
  final String name;
  final String countryCode;
}

abstract class LanguageLocals {
  static final Map<String, LanguageName> isoLangs = {
    'en': const LanguageName(
      name: LocaleKeys.languageScreenEnglish,
      countryCode: 'US',
    ),
    'ja': const LanguageName(
      name: LocaleKeys.languageScreenJapanese,
      countryCode: 'JP',
    ),
    'vi': const LanguageName(
      name: LocaleKeys.languageScreenVietnamese,
      countryCode: 'VN',
    ),
  };

  static Locale get defaultLocale {
    return supportedLocales.first;
  }

  static List<Locale> get supportedLocales {
    return isoLangs.entries
        .map((e) => Locale(e.key, e.value.countryCode))
        .toList();
  }

  static LanguageName getDisplayLanguage(key) {
    if (isoLangs.containsKey(key)) {
      return isoLangs[key]!;
    } else {
      throw Exception('Language key incorrect');
    }
  }
}

''';
  }
}
