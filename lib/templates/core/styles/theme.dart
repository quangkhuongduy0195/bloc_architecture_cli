class ThemeGenerator {
  /// Generates the code for themes.
  static String gen() {
    return '''
  
part of '../config.dart';

const primary = Color(0xffEF3E23);

const primaryVariant = Color(0xffF7901E);

const error = Color(0xffF03036);

const hintColor = Color(0xffBBBABA);

const greyText = Color(0xff949CA9);

const blue = Color(0xff4983cf);

LinearGradient buttonGradient = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[primary, primaryVariant],
  tileMode: TileMode.mirror,
);

const lightStatusBar = SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const darkStatusBar = SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
// Neutral Variant/Neutral 30

ThemeData lightTheme(BuildContext context) {
  final baseTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xffF9F9F9),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        labelColor: Colors.black,
        titleColor: Color(0xff434343),
        subtitleColor: Color(0xff848484),
      ),
    ],
    appBarTheme: AppBarTheme(
      systemOverlayStyle: darkStatusBar,
      titleTextStyle: GoogleFonts.inter(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: primary,
      error: error,
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) {
        return const Icon(
          Icons.keyboard_arrow_left,
          size: 28,
        );
      },
    ),
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
  );
}

ThemeData darkTheme(BuildContext context) {
  final baseTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xff1a1a1a),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        labelColor: Colors.white,
        titleColor: Color(0xffe0e0e0),
        subtitleColor: Color(0xff848484),
      ),
    ],
    appBarTheme: AppBarTheme(
      systemOverlayStyle: lightStatusBar,
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primary,
      error: error,
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) {
        return const Icon(
          Icons.keyboard_arrow_left,
          size: 28,
        );
      },
    ),
  );
  return baseTheme.copyWith(
    textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
  );
}

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    this.labelColor,
    this.background,
    this.titleColor,
    this.subtitleColor,
  });

  final Color? labelColor;
  final Color? background;
  final Color? titleColor;
  final Color? subtitleColor;
  @override
  AppColors copyWith({
    Color? labelColor,
    Color? background,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return AppColors(
      labelColor: labelColor ?? this.labelColor,
      background: background ?? this.background,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      labelColor: Color.lerp(labelColor, other.labelColor, t),
      background: Color.lerp(background, other.background, t),
      titleColor: Color.lerp(titleColor, other.titleColor, t),
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t),
    );
  }

  @override
  String toString() =>
      'AppColors(labelColor: \$labelColor, background: \$background, titleColor: \$titleColor, subtitleColor: \$subtitleColor)';
}
''';
  }
}
