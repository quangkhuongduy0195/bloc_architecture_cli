class WidgetButtonCustomGenerator {
  static String gen() {
    return '''import 'package:auto_size_text/auto_size_text.dart';
import '../../core/config.dart';
import 'indicators/loading_indicator.dart';

enum ButtonType { normal, outline, text, icon }

class ButtonCustom extends StatelessWidget {
  factory ButtonCustom.outline({
    required String text,
    VoidCallback? onPressed,
    Color? textColor,
    Color? borderColor,
    double? radius,
    double? borderWidth,
    double? height = 45,
    double? width,
    double? fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    bool isLoading = false,
    Color backgroundColor = Colors.transparent,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    Color? disableBackground,
    double? letterSpacing,
    double? elevation,
  }) {
    return ButtonCustom(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outline,
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      radius: radius ?? 30,
      borderWidth: borderWidth ?? 1,
      height: height,
      width: width,
      fontSize: fontSize,
      fontWeight: fontWeight,
      padding: padding,
      isLoading: isLoading,
      margin: margin,
      disableBackground: disableBackground,
      letterSpacing: letterSpacing,
      elevation: elevation,
    );
  }

  factory ButtonCustom.text({
    required String text,
    VoidCallback? onPressed,
    Color? textColor,
    double? height,
    double? width,
    double? fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    bool isLoading = false,
    Color? backgroundColor,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    EdgeInsetsGeometry? padding,
    double? letterSpacing,
  }) {
    return ButtonCustom(
      text: text,
      onPressed: onPressed,
      type: ButtonType.text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      height: height,
      width: width,
      fontSize: fontSize,
      fontWeight: fontWeight,
      isLoading: isLoading,
      margin: margin,
      padding: padding,
      letterSpacing: letterSpacing,
    );
  }

  factory ButtonCustom.icon({
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    Color? textColor,
    Color? backgroundColor,
    double? radius,
    double height = 45,
    double? width,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
    bool isLoading = false,
    Color? borderColor,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    EdgeInsetsGeometry? padding,
    bool showBorder = false,
    double? letterSpacing,
    double? elevation,
  }) {
    return ButtonCustom(
      text: text,
      borderColor: borderColor,
      onPressed: onPressed,
      textColor: textColor,
      backgroundColor: backgroundColor,
      radius: radius ?? 30,
      height: height,
      width: width,
      fontSize: fontSize,
      fontWeight: fontWeight,
      isLoading: isLoading,
      icon: icon,
      type: ButtonType.icon,
      margin: margin,
      padding: padding,
      showBorder: showBorder,
      letterSpacing: letterSpacing,
      elevation: elevation,
    );
  }
  const ButtonCustom({
    super.key,
    required this.text,
    this.type = ButtonType.normal,
    this.textColor,
    this.backgroundColor,
    this.disableBackground,
    this.fontSize = 16,
    this.radius = 30,
    this.borderWidth = 1,
    this.height = 45.0,
    this.width,
    this.borderColor,
    this.onPressed,
    this.elevation,
    this.tapTargetSize = MaterialTapTargetSize.shrinkWrap,
    this.padding,
    this.fontWeight = FontWeight.bold,
    this.isLoading = false,
    this.icon,
    this.showBorder = false,
    this.margin = EdgeInsets.zero,
    this.letterSpacing,
  });

  /// A button that can be customized with different styles.
  /// [ButtonType.normal] is a normal button,
  /// [ButtonType.outline] is a button with a border,
  /// [ButtonType.text] is a button with text only,
  /// [ButtonType.icon] is a button with an icon.
  final ButtonType type;

  /// The color of the text.
  /// If the type is [ButtonType.outline], the default value is [context.primary].
  final Color? textColor,

      /// The color of the border.
      /// If the type is [ButtonType.outline], the default value is [context.primary].
      borderColor,

      /// The color of the background.
      /// If the type is [ButtonType.outline], the default value is [Colors.white].
      backgroundColor;

  /// The radius of the button.
  final double radius,

      /// The width of the border.
      borderWidth;

  /// The height, width, elevation, and font size of the button.
  /// The default value is [45.0], [double.infinity], [0.0], and [16.0].
  final double? height, width, elevation, fontSize;

  /// The callback function when the button is pressed.
  final VoidCallback? onPressed;

  /// The text content of the button.
  final String text;

  /// The size of the tap target.
  final MaterialTapTargetSize? tapTargetSize;

  /// The padding of the button.
  final EdgeInsetsGeometry? padding;

  /// The font weight of the text.
  /// The default value is [FontWeight.w600].
  final FontWeight fontWeight;

  /// The loading state of the button.
  /// The default value is [false].
  final bool isLoading;

  /// The Border of the button
  /// The default value is [false].
  final bool showBorder;

  /// The icon of the button.
  final Widget? icon;

  final EdgeInsetsGeometry margin;

  final Color? disableBackground;

  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    Size? size;

    Size minimumSize = const Size(64, 40);
    if (width != null && height != null) {
      size = Size(width!, height!);
      minimumSize = size;
    } else if (width != null) {
      size = Size.fromWidth(width!);
      minimumSize = Size(width!, minimumSize.height);
    } else if (height != null) {
      size = Size.fromHeight(height!);
      minimumSize = Size(minimumSize.width, height!);
    }

    BorderSide side = BorderSide(
      width: borderWidth,
      color: borderColor ?? textColor ?? context.primary,
    );

    Color bgColor = backgroundColor ??
        (type == ButtonType.outline ? Colors.white : context.primary);

    Color? titleColor = textColor ??
        switch (type) {
          ButtonType.outline => context.primary,
          ButtonType.text => context.primary,
          _ => Colors.white,
        };

    final widget = isLoading
        ? LoadingIndicator(color: titleColor)
        : AutoSizeText(
            text,
            style: context.bodyMedium?.copyWith(
              fontSize: fontSize,
              color: titleColor,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
            ),
            maxLines: 1,
          );

    final buttonStyle = ElevatedButton.styleFrom(
      disabledBackgroundColor: disableBackground ?? bgColor.withOpacity(0.7),
      backgroundColor: bgColor,
      foregroundColor: titleColor,
      fixedSize: size,
      minimumSize: minimumSize,
      elevation: elevation,
      tapTargetSize: tapTargetSize,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: type == ButtonType.outline
            ? side
            : showBorder
                ? side
                : BorderSide.none,
      ),
    );
    return Padding(
      padding: margin,
      child: switch (type) {
        ButtonType.text => TextButton(
            style: TextButton.styleFrom(
              padding: padding,
              tapTargetSize: tapTargetSize,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            onPressed: isLoading ? null : onPressed,
            child: widget,
          ),
        ButtonType.icon => ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            icon: (isLoading || icon == null) ? const SizedBox() : icon!,
            label: widget,
          ),
        _ => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: widget,
          )
      },
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    this.onPressed,
    required this.text,
    this.colors,
    this.height = 48,
    this.textColor = Colors.white,
    this.loading = false,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.mainAxisSize = MainAxisSize.max,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
    this.margin = EdgeInsets.zero,
    this.radius = 100,
    this.letterSpacing = 0.85,
    this.icon,
    super.key,
  });
  final VoidCallback? onPressed;
  final List<Color>? colors;
  final String text;
  final Widget? icon;
  final double fontSize, height, radius, letterSpacing;
  final Color textColor;
  final FontWeight fontWeight;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry margin, padding;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final gradient = colors ??
        [
          primary,
          primaryVariant,
        ];
    return Padding(
      padding: margin,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: loading ? null : onPressed,
          child: Ink(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: onPressed == null
                    ? gradient.map((e) => e.withOpacity(.5)).toList()
                    : gradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Padding(
              padding: padding,
              child: loading
                  ? LoadingIndicator(color: textColor)
                  : Row(
                      mainAxisSize: mainAxisSize,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const WidthBox(8),
                        ],
                        Flexible(
                          child: AutoSizeText(
                            text,
                            style: context.bodyMedium?.copyWith(
                              fontSize: fontSize,
                              color: textColor,
                              fontWeight: fontWeight,
                              letterSpacing: letterSpacing,
                            ),
                            maxLines: 1,
                            minFontSize: 6,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
''';
  }
}
