class ContextExtensionGenerator {
  static String gen() {
    return '''import 'package:get_it/get_it.dart';

import '../../gen/l10n/app_localizations.dart';
import '../common/common/common_bloc.dart';
import '../config.dart';

extension ContextExt on BuildContext {
  ///[AppColors] instance from the closest [Theme] ancestor
  AppColors get appColor => Theme.of(this).extension<AppColors>()!;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get primary => colorScheme.primary;

  Color get primaryContainer => colorScheme.primaryContainer;

  Color get secondary => colorScheme.secondary;

  Color get tertiary => colorScheme.tertiary;

  Color get secondaryContainer => colorScheme.secondaryContainer;

  Color get surface => colorScheme.surface;

  Color get error => colorScheme.error;

  Color get onPrimary => colorScheme.onPrimary;

  Color get onSecondary => colorScheme.onSecondary;

  Color get onSurface => colorScheme.onSurface;

  Color get onError => colorScheme.onError;

  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  bool get isIpad => MediaQuery.of(this).size.shortestSide >= 600;

  bool get isTablet =>
      MediaQuery.of(this).size.shortestSide >= 600 &&
      MediaQuery.of(this).size.longestSide >= 1000;

  bool get isMobile => MediaQuery.of(this).size.shortestSide < 600;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
      );
  }

  Locale get locale => Localizations.localeOf(this);

  AppLocalizations get l10n => AppLocalizations.of(this)!;

  Future<void> setLocale(Locale locale) async {
    await AppLocalizations.delegate.load(locale);
    GetIt.I<CommonBloc>().add(ChangeLanguage(locale));
  }
}


''';
  }
}
