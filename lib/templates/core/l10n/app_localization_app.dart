class l10nAppLocalizationAppGenerator {
  /// Generates the code for the [AppLocalizations] widget.
  static String gen() {
    return '''import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localization.dart';
import 'asset_loader.dart';
import 'localization.dart';

/// A widget that provides localization for the app.
///
/// This widget should be used as the root widget of your app. It provides
/// the following features:
///
/// * **Localization:** Loads translations from the specified path and provides
///   them to the app.
/// * **Locale management:** Allows you to set the locale of the app and
///   persist it across app sessions.
/// * **Error handling:** Provides a mechanism for handling errors that occur
///   while loading translations.
///
/// **Usage:**
///
/// ```dart
/// import 'package:app_localization/app_localization.dart';
///
/// void main() {
///   runApp(
///     AppLocalizationApp(
///       path: 'assets/translations',
///       supportedLocales: [
///         Locale('en'),
///         Locale('es'),
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
class AppLocalizations extends StatefulWidget {
  /// Creates a new [AppLocalizationApp] widget.
  const AppLocalizations({
    super.key,
    this.assetLoader = const RootBundleAssetLoader(),
    required this.path,
    this.startLocale,
    required this.child,
    required this.supportedLocales,
    this.fallbackLocale,
    this.ignorePluralRules = true,
    this.useOnlyLangCode = false,
    this.saveLocale = true,
    this.extraAssetLoaders,
    this.errorWidget,
  });

  /// The path to the translations files.
  final String path;

  /// The asset loader to use for loading translations.
  ///
  /// Defaults to [RootBundleAssetLoader].
  final AssetLoader assetLoader;

  /// The initial locale of the app.
  ///
  /// If not provided, the device's locale will be used.
  final Locale? startLocale;

  /// The list of supported locales.
  final List<Locale> supportedLocales;

  /// Locale when the locale is not in the list
  final Locale? fallbackLocale;

  /// The widget to display.
  final Widget child;

  /// Whether to ignore plural rules when loading translations.
  ///
  /// Defaults to `true`.
  final bool ignorePluralRules;

  /// Whether to use only the language code when loading translations.
  ///
  /// Defaults to `false`.
  final bool useOnlyLangCode;

  /// Whether to save the locale of the app.
  ///
  /// Defaults to `true`.
  final bool saveLocale;

  /// A list of additional asset loaders to use for loading translations.
  final List<AssetLoader>? extraAssetLoaders;

  /// A widget to display if an error occurs while loading translations.
  final Widget Function(FlutterError? message)? errorWidget;

  /// Returns the [AppLocalizationProvider] for the given context.
  // ignore: library_private_types_in_public_api
  static _AppLocalizationProvider? of(BuildContext context) =>
      _AppLocalizationProvider.of(context);

  /// Initializes the localization controller.
  static Future<void> ensureInitialized() =>
      AppLocalizationController.initialize();

  @override
  State<AppLocalizations> createState() => _AppLocalizationsState();
}

/// The state of the [AppLocalizations] widget.
class _AppLocalizationsState extends State<AppLocalizations> {
  /// The localization controller.
  late AppLocalizationController localizationController;

  /// The error that occurred while loading translations.
  FlutterError? translationsLoadError;

  @override
  void initState() {
    localizationController = AppLocalizationController(
      supportedLocales: widget.supportedLocales,
      assetLoader: widget.assetLoader,
      startLocale: widget.startLocale,
      saveLocale: widget.saveLocale,
      useOnlyLangCode: widget.useOnlyLangCode,
      extraAssetLoaders: widget.extraAssetLoaders,
      fallbackLocale: widget.fallbackLocale,
      path: widget.path,
      onLoadError: (FlutterError e) {
        setState(() {
          translationsLoadError = e;
        });
      },
    );

    localizationController.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    localizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (translationsLoadError != null) {
      return widget.errorWidget != null
          ? widget.errorWidget!(translationsLoadError)
          : ErrorWidget(translationsLoadError!);
    }
    return _AppLocalizationProvider(
      widget,
      localizationController,
      delegate: _AppLocalizationDelegate(
        useFallbackTranslationsForEmptyResources: true,
        localizationController: localizationController,
        supportedLocales: widget.supportedLocales,
        ignorePluralRules: widget.ignorePluralRules,
      ),
    );
  }
}

/// A widget that provides localization for the app.
///
/// This widget is used by the [AppLocalizationApp] widget to provide
/// localization to the app.
class _AppLocalizationProvider extends InheritedWidget {
  /// Creates a new [AppLocalizationProvider] widget.
  _AppLocalizationProvider(
    this.parent,
    this._localeState, {
    required this.delegate,
  })  : currentLocale = _localeState.locale,
        super(child: parent.child) {
    AppLocalizationLogger.debug('Init provider');
  }

  /// The parent [AppLocalizationApp] widget.
  final AppLocalizations parent;

  /// The localization controller.
  final AppLocalizationController _localeState;

  AppLocalizationController get localeState => _localeState;

  /// The current locale of the app.
  final Locale? currentLocale;

  /// The localization delegate.
  final _AppLocalizationDelegate delegate;

  /// The list of localization delegates.
  List<LocalizationsDelegate> get delegates => [
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  /// The list of supported locales.
  List<Locale> get supportedLocales => parent.supportedLocales;

  /// The current locale of the app.
  Locale get locale => _localeState.locale;

  /// Sets the locale of the app.
  Future<void> setLocale(Locale locale) async {
    if (locale != _localeState.locale) {
      assert(parent.supportedLocales.contains(locale));
      await _localeState.setLocale(locale);
    }
  }

  /// Clears a saved locale from device storage
  Future<void> deleteSaveLocale() async {
    await _localeState.deleteSaveLocale();
  }

  /// Get fallback locale
  Locale? get fallbackLocale => parent.fallbackLocale;

  /// The device's locale.
  Locale get deviceLocale => _localeState.deviceLocale;

  /// The saved locale of the app.
  Locale? get savedLocale => _localeState.savedLocale;

  /// Resets the locale of the app to the device's locale.
  Future<void> resetLocale() => _localeState.resetLocale();

  @override
  bool updateShouldNotify(_AppLocalizationProvider oldWidget) {
    return oldWidget.currentLocale != locale;
  }

  /// Returns the [AppLocalizationProvider] for the given context.
  static _AppLocalizationProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AppLocalizationProvider>();
}

/// A localization delegate that loads translations from the specified path.
///
/// This delegate is used by the [AppLocalizationProvider] widget to load
/// translations for the app.
class _AppLocalizationDelegate extends LocalizationsDelegate<Localization> {
  /// Creates a new [AppLocalizationDelegate] widget.
  _AppLocalizationDelegate({
    required this.useFallbackTranslationsForEmptyResources,
    this.ignorePluralRules = true,
    this.localizationController,
    this.supportedLocales,
  }) {
    AppLocalizationLogger.debug('Init Localization Delegate');
  }

  /// The list of supported locales.
  final List<Locale>? supportedLocales;

  /// The localization controller.
  final AppLocalizationController? localizationController;

  /// Whether to use fallback translations for empty resources.
  final bool useFallbackTranslationsForEmptyResources;

  /// Whether to ignore plural rules when loading translations.
  final bool ignorePluralRules;

  @override
  bool isSupported(Locale locale) => supportedLocales!.contains(locale);

  @override
  Future<Localization> load(Locale value) async {
    AppLocalizationLogger.debug('Load Localization Delegate');
    if (localizationController!.translations == null) {
      await localizationController!.loadTranslations();
    }

    Localization.load(
      value,
      translations: localizationController!.translations,
      fallbackTranslations: localizationController!.fallbackTranslations,
      useFallbackTranslationsForEmptyResources:
          useFallbackTranslationsForEmptyResources,
      ignorePluralRules: ignorePluralRules,
    );
    return Localization.instance;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}
''';
  }
}
