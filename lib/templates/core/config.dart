class ConfigGenerator {
  /// Generates the code for the config file.
  static String gen() {
    return '''
library config;

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../di/injection.dart';
import 'l10n/app_localization_app.dart';
import 'common/base/app_bloc_observer.dart';
import 'common/base/mixin/persisted_mixin.dart';
import 'config.dart';

export 'package:auto_route/auto_route.dart';
export 'package:auto_size_text/auto_size_text.dart';
export 'package:collection/collection.dart';
export 'package:flutter/material.dart' hide Page, TextDirection;
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:velocity_x/velocity_x.dart' hide VxThemeExtension;

export '../core/l10n/public_ext.dart';
export '../core/collections/collections.dart';
export '../core/collections/locale_keys.g.dart';
export '../core/extensions/extensions.dart';
export '../core/utils/logger.dart';
export '../widgets/common/title_widget.dart';

part 'styles/dimensions.dart';
part 'styles/theme.dart';

class Configs {
  /// [title] is the title of the app.
  static const String appName = 'Bloc Architecture';

  /// [baseUrl] is the base url for the API.
  static const String baseUrl = 'https://dummyjson.com';

  /// [keyAcceptToken] is the key for the access token in the header.
  static const String keyAcceptToken = 'access_token';

  /// [uiW] is the width of the app.
  static const double uiW = 375.0;

  /// [uiH] is the height of the app.
  static const double uiH = 812.0;

  /// [uiTextScale] is the text scale of the app.
  static const double uiTextScale = 1.0;

  /// [designSize] is the design size of the app.
  static const designSize = Size(uiW, uiH);

  /// [minTextAdapter] setting [ScreenUtilInit.minTextAdapt] to true will allow the text to scale down on smaller screens.
  static const bool minTextAdapter = true;

  /// [splitScreenMode] setting [ScreenUtilInit.splitScreenMode] to true will allow the app to adapt to split screen mode.
  /// This is useful for tablets and desktops.
  /// If the app is not designed to support split screen mode, set this to false.
  static const bool splitScreenMode = true;

  static Future<void> init(Function() runApp) async {
    configureDependencies();

    WidgetsFlutterBinding.ensureInitialized();
    await AppLocalizations.ensureInitialized();

    final path = (await getApplicationDocumentsDirectory()).path;
    Hive.init(path);
    await PersistedStateMixin.initializeBoxes(
      path: path,
    );
    Bloc.observer = AppBlocObserver();

    runApp();
  }
}
''';
  }
}
