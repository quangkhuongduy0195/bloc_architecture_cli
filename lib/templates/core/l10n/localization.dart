class l10nLocalizationGenerator {
  /// Generates the code for the [Localization] class.
  static String gen() {
    return '''

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../utilities/logger.dart';
import 'plural_rules.dart';
import 'translations.dart';

/// Localization class for managing translations and pluralization.
class Localization {
  Localization();
  Translations? _translations, _fallbackTranslations;
  late Locale _locale;

  final RegExp _replaceArgRegex = RegExp('{}');
  final RegExp _linkKeyMatcher =
      RegExp(r'(?:@(?:\.[a-z]+)?:(?:[\w\-_|.]+|\([\w\-_|.]+\)))');
  final RegExp _linkKeyPrefixMatcher = RegExp(r'^@(?:\.([a-z]+))?:');
  final RegExp _bracketsMatcher = RegExp('[()]');
  final _modifiers = <String, String Function(String?)>{
    'upper': (String? val) => val!.toUpperCase(),
    'lower': (String? val) => val!.toLowerCase(),
    'capitalize': (String? val) =>
        '\${val![0].toUpperCase()}\${val.substring(1)}',
  };

  bool _useFallbackTranslationsForEmptyResources = false;
  bool _ignorePluralRules = false;

  static Localization? _instance;

  /// Returns the singleton instance of the Localization class.
  static Localization get instance => _instance ?? (_instance = Localization());

  /// Returns the current translations.
  Translations? get translations => _translations;

  /// Returns the Localization instance associated with the given context.
  static Localization? of(BuildContext context) =>
      Localizations.of<Localization>(context, Localization);

  /// Loads the translations and fallback translations.
  ///
  /// [locale] The current locale.
  /// [translations] The main translations.
  /// [fallbackTranslations] The fallback translations.
  /// [useFallbackTranslationsForEmptyResources] Whether to use fallback translations for empty resources.
  /// [ignorePluralRules] Whether to ignore plural rules.
  static bool load(
    Locale locale, {
    Translations? translations,
    Translations? fallbackTranslations,
    bool useFallbackTranslationsForEmptyResources = false,
    bool ignorePluralRules = true,
  }) {
    instance._locale = locale;
    instance._translations = translations;
    instance._fallbackTranslations = fallbackTranslations;
    instance._useFallbackTranslationsForEmptyResources =
        useFallbackTranslationsForEmptyResources;
    instance._ignorePluralRules = ignorePluralRules;
    return translations == null ? false : true;
  }

  /// Translates a key with optional arguments, named arguments, and gender.
  ///
  /// [key] The localization key.
  /// [args] List of localized strings. Replaces {} left to right.
  /// [namedArgs] Map of localized strings. Replaces the name keys {key_name} according to its name.
  /// [gender] Gender switcher. Changes the localized string based on gender string.
  String tr(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    late String res;

    if (gender != null) {
      res = _gender(key, gender: gender);
    } else {
      res = _resolve(key);
    }

    res = _replaceLinks(res);

    res = _replaceNamedArgs(res, namedArgs);

    return _replaceArgs(res, args);
  }

  /// Replaces links in the translated string.
  ///
  /// [res] The translated string.
  /// [logging] Whether to log undefined modifiers.
  String _replaceLinks(String res, {bool logging = true}) {
    final matches = _linkKeyMatcher.allMatches(res);
    var result = res;

    for (final match in matches) {
      final link = match[0]!;
      final linkPrefixMatches = _linkKeyPrefixMatcher.allMatches(link);
      final linkPrefix = linkPrefixMatches.first[0]!;
      final formatterName = linkPrefixMatches.first[1];

      // Remove the leading @:, @.case: and the brackets
      final linkPlaceholder =
          link.replaceAll(linkPrefix, '').replaceAll(_bracketsMatcher, '');

      var translated = _resolve(linkPlaceholder);

      if (formatterName != null) {
        if (_modifiers.containsKey(formatterName)) {
          translated = _modifiers[formatterName]!(translated);
        } else {
          if (logging) {
            Logger.log(
              'Undefined modifier \$formatterName, available modifiers: \${_modifiers.keys.toString()}',
            );
          }
        }
      }

      result =
          translated.isEmpty ? result : result.replaceAll(link, translated);
    }

    return result;
  }

  /// Replaces arguments in the translated string.
  ///
  /// [res] The translated string.
  /// [args] The arguments to replace.
  String _replaceArgs(String res, List<String>? args) {
    if (args == null || args.isEmpty) return res;
    for (var str in args) {
      res = res.replaceFirst(_replaceArgRegex, str);
    }
    return res;
  }

  /// Replaces named arguments in the translated string.
  ///
  /// [res] The translated string.
  /// [args] The named arguments to replace.
  String _replaceNamedArgs(String res, Map<String, String>? args) {
    if (args == null || args.isEmpty) return res;
    args.forEach(
      (String key, String value) =>
          res = res.replaceAll(RegExp('{\$key}'), value),
    );
    return res;
  }

  /// Returns the plural rule for the given locale and value.
  static PluralRule? _pluralRule(String? locale, num howMany) {
    if (instance._ignorePluralRules) {
      return () => _pluralCaseFallback(howMany);
    }
    startRuleEvaluation(howMany);
    return pluralRules[locale];
  }

  /// Returns the fallback plural case for the given value.
  static PluralCase _pluralCaseFallback(num value) {
    switch (value) {
      case 0:
        return PluralCase.ZERO;
      case 1:
        return PluralCase.ONE;
      case 2:
        return PluralCase.TWO;
      default:
        return PluralCase.OTHER;
    }
  }

  /// Translates a key based on the plural rule for the given value.
  ///
  /// [key] The localization key.
  /// [value] The value to use for pluralization.
  /// [args] List of localized strings. Replaces {} left to right.
  /// [namedArgs] Map of localized strings. Replaces the name keys {key_name} according to its name.
  /// [name] The name to use for the formatted value.
  /// [format] The number format to use for the formatted value.
  String plural(
    String key,
    num value, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? name,
    NumberFormat? format,
  }) {
    late String res;

    final pluralRule = _pluralRule(_locale.languageCode, value);
    final pluralCase =
        pluralRule != null ? pluralRule() : _pluralCaseFallback(value);

    switch (pluralCase) {
      case PluralCase.ZERO:
        res = _resolvePlural(key, 'zero');
        break;
      case PluralCase.ONE:
        res = _resolvePlural(key, 'one');
        break;
      case PluralCase.TWO:
        res = _resolvePlural(key, 'two');
        break;
      case PluralCase.FEW:
        res = _resolvePlural(key, 'few');
        break;
      case PluralCase.MANY:
        res = _resolvePlural(key, 'many');
        break;
      case PluralCase.OTHER:
        res = _resolvePlural(key, 'other');
        break;
    }

    final formattedValue = format == null ? '\$value' : format.format(value);

    if (name != null) {
      namedArgs = {...?namedArgs, name: formattedValue};
    }
    res = _replaceNamedArgs(res, namedArgs);

    return _replaceArgs(res, args ?? [formattedValue]);
  }

  /// Translates a key based on the gender.
  ///
  /// [key] The localization key.
  /// [gender] The gender to use for translation.
  String _gender(String key, {required String gender}) {
    return _resolve('\$key.\$gender');
  }

  /// Resolves the plural translation for the given key and subkey.
  ///
  /// [key] The localization key.
  /// [subKey] The subkey to use for pluralization.
  String _resolvePlural(String key, String subKey) {
    if (subKey == 'other') return _resolve('\$key.other');

    final tag = '\$key.\$subKey';
    var resource =
        _resolve(tag, logging: false, fallback: _fallbackTranslations != null);
    if (resource == tag) {
      resource = _resolve('\$key.other');
    }
    return resource;
  }

  /// Resolves the translation for the given key.
  ///
  /// [key] The localization key.
  /// [logging] Whether to log if the key is not found.
  /// [fallback] Whether to use fallback translations.
  String _resolve(String key, {bool logging = true, bool fallback = true}) {
    var resource = _translations?.get(key);
    if (resource == null ||
        (_useFallbackTranslationsForEmptyResources && resource.isEmpty)) {
      if (logging) {
        Logger.log('Localization key [\$key] not found');
      }
      if (_fallbackTranslations == null || !fallback) {
        return key.split('.').last;
      } else {
        resource = _fallbackTranslations?.get(key);
        if (resource == null ||
            (_useFallbackTranslationsForEmptyResources && resource.isEmpty)) {
          if (logging) {
            Logger.log('Fallback localization key [\$key] not found');
          }
          return key;
        }
      }
    }
    return resource;
  }

  /// Checks if the given key exists in the translations.
  ///
  /// [key] The localization key.
  bool exists(String key) {
    return _translations?.get(key) != null;
  }
}
''';
  }
}
