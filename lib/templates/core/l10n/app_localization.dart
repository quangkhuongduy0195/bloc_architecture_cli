class l10nAppLocalizationGenerator {
  /// Generates the code for the [AppLocalizations] widget.
  static String gen() {
    return '''import 'package:flutter/material.dart';

library app_localization;

import 'dart:developer' as developer;

import 'package:intl/intl_standalone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config.dart';
import 'asset_loader.dart';
import 'translations.dart';
part 'utils.dart';

/// Controller for the localization of the app.
class AppLocalizationController extends ChangeNotifier {
  AppLocalizationController({
    required List<Locale> supportedLocales,
    required this.assetLoader,
    required this.saveLocale,
    required this.onLoadError,
    required this.path,
    required this.useOnlyLangCode,
    this.extraAssetLoaders,
    Locale? startLocale,
    Locale? fallbackLocale,
  }) {
    _supportedLocales = supportedLocales;
    _fallbackLocale = fallbackLocale;
    if (_savedLocale == null && startLocale != null) {
      _locale = selectLocaleFrom(
        supportedLocales,
        startLocale,
        fallbackLocale: fallbackLocale,
      );
    } else if (saveLocale && _savedLocale != null) {
      _locale = selectLocaleFrom(
        supportedLocales,
        _savedLocale!,
        fallbackLocale: fallbackLocale,
      );
    } else {
      _locale = selectLocaleFrom(
        supportedLocales,
        _deviceLocale,
        fallbackLocale: fallbackLocale,
      );
    }
  }

  final AssetLoader assetLoader;
  final bool saveLocale;
  final Function(FlutterError e) onLoadError;
  final String path;
  final bool useOnlyLangCode;

  List<AssetLoader>? extraAssetLoaders;

  late Locale _locale;

  Locale get locale => _locale;

  static late Locale _deviceLocale;

  // /// The current locale of the app.
  static Locale? _savedLocale;

  Locale? _fallbackLocale;

  List<Locale>? _supportedLocales;

  Locale get deviceLocale => _deviceLocale;

  Locale? get savedLocale => _savedLocale;

  // /// The translations for the current locale.
  Translations? _translations, _fallbackTranslations;
  Translations? get translations => _translations;
  Translations? get fallbackTranslations => _fallbackTranslations;
  static Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final strLocale = preferences.getString('ff_language_app');
    _savedLocale = strLocale?.toLocale();
    final foundPlatformLocale = await findSystemLocale();
    _deviceLocale = foundPlatformLocale.toLocale();
  }

  static Locale selectLocaleFrom(
    List<Locale> supportedLocales,
    Locale deviceLocale, {
    Locale? fallbackLocale,
  }) {
    final selectedLocale = supportedLocales.firstWhere(
      (locale) => locale.supports(deviceLocale),
      orElse: () => _getFallbackLocale(
        supportedLocales,
        fallbackLocale,
        deviceLocale: deviceLocale,
      ),
    );
    return selectedLocale;
  }

  //Get fallback Locale
  static Locale _getFallbackLocale(
    List<Locale> supportedLocales,
    Locale? fallbackLocale, {
    final Locale? deviceLocale,
  }) {
    if (deviceLocale != null) {
      // a locale that matches the language code of the device locale is
      // preferred over the fallback locale
      final deviceLanguage = deviceLocale.languageCode;
      for (Locale locale in supportedLocales) {
        if (locale.languageCode == deviceLanguage) {
          return locale;
        }
      }
    }
    //If fallbackLocale not set then return first from supportedLocales
    if (fallbackLocale != null) {
      return fallbackLocale;
    } else {
      return supportedLocales.first;
    }
  }

  Future<Map<String, dynamic>> _combineAssetLoaders({
    required String path,
    required Locale locale,
    required AssetLoader assetLoader,
    required bool useOnlyLangCode,
    List<AssetLoader>? extraAssetLoaders,
  }) async {
    final result = <String, dynamic>{};
    final loaderFutures = <Future<Map<String, dynamic>?>>[];

    // need scriptCode, it might be better to use ignoreCountryCode as the variable name of useOnlyLangCode
    final Locale desiredLocale = useOnlyLangCode
        ? Locale.fromSubtags(
            languageCode: locale.languageCode,
            scriptCode: locale.scriptCode,
          )
        : locale;

    List<AssetLoader> loaders = [
      assetLoader,
      if (extraAssetLoaders != null) ...extraAssetLoaders,
    ];

    for (final loader in loaders) {
      loaderFutures.add(loader.load(path, desiredLocale));
    }

    await Future.wait(loaderFutures).then((List<Map<String, dynamic>?> value) {
      for (final Map<String, dynamic>? map in value) {
        if (map != null) {
          result.addAllRecursive(map);
        }
      }
    });

    return result;
  }

  Future<Map<String, dynamic>> loadTranslationData(Locale locale) async =>
      _combineAssetLoaders(
        path: path,
        locale: locale,
        assetLoader: assetLoader,
        useOnlyLangCode: useOnlyLangCode,
        extraAssetLoaders: extraAssetLoaders,
      );
  Future loadTranslations() async {
    Map<String, dynamic> data;
    try {
      data = Map.from(await loadTranslationData(_locale));
      _translations = Translations(data);
    } on FlutterError catch (e) {
      onLoadError(e);
    } catch (e) {
      onLoadError(FlutterError(e.toString()));
    }
  }

  Future<void> setLocale(Locale l) async {
    _locale = l;
    await loadTranslations();
    notifyListeners();
    AppLocalizationLogger.debug('Locale \$locale changed');
    await _saveLocale(_locale);
  }

  Future<void> _saveLocale(Locale? locale) async {
    if (!saveLocale) return;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('ff_language_app', locale.toString());
  }

  Future<void> resetLocale() async {
    final locale = selectLocaleFrom(
      _supportedLocales!,
      deviceLocale,
      fallbackLocale: _fallbackLocale,
    );

    await setLocale(locale);
  }

  Future<void> deleteSaveLocale() async {
    _savedLocale = null;
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('ff_language_app');
    AppLocalizationLogger.debug('Saved locale deleted');
  }
}

@visibleForTesting
extension LocaleExtension on Locale {
  bool supports(Locale locale) {
    if (this == locale) {
      return true;
    }
    if (languageCode != locale.languageCode) {
      return false;
    }
    if (countryCode != null &&
        countryCode!.isNotEmpty &&
        countryCode != locale.countryCode) {
      return false;
    }
    if (scriptCode != null && scriptCode != locale.scriptCode) {
      return false;
    }

    return true;
  }
}
''';
  }
}
