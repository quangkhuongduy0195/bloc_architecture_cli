class WidgetSettingUiGenerator {
  static String gen() {
    return '''import 'package:flutter/cupertino.dart';

import '../core/config.dart';

enum SettingsTileType { simpleTile, switchTile, navigationTile }

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: TextApp.bold(title),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffF7901E).withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  SettingsTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.descriptionInlineIos = false,
    this.needToShowDivider = false,
    this.onPressed,
    this.backgroundColor,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10),
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    tileType = SettingsTileType.simpleTile;
  }

  SettingsTile.navigation({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.descriptionInlineIos = false,
    this.needToShowDivider = false,
    this.onPressed,
    this.backgroundColor,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10),
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    tileType = SettingsTileType.navigationTile;
  }

  SettingsTile.switchTile({
    required this.initialValue,
    required this.onToggle,
    this.descriptionInlineIos = false,
    this.needToShowDivider = false,
    this.activeSwitchColor,
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.backgroundColor,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10),
    super.key,
  }) {
    value = null;
    tileType = SettingsTileType.switchTile;
  }

  /// The widget at the beginning of the tile
  final Widget? leading;

  /// The Widget at the end of the tile
  final Widget? trailing;

  /// The widget at the center of the tile
  final Widget title;

  /// The widget at the bottom of the [title]
  final Widget? description;

  final bool descriptionInlineIos;

  final Color? backgroundColor;

  /// A function that is called by tap on a tile
  final VoidCallback? onPressed;

  /// Whether to show a divider after the tile
  final bool needToShowDivider;

  final EdgeInsets contentPadding;

  late final Color? activeSwitchColor;
  late final Widget? value;
  late final Function(bool value)? onToggle;
  late final SettingsTileType tileType;
  late final bool? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          clipBehavior: Clip.antiAlias,
          color: backgroundColor,
          child: InkWell(
            onTap: onPressed,
            child: ClipRRect(
              child: Container(
                padding: tileType == SettingsTileType.switchTile
                    ? const EdgeInsetsDirectional.only(start: 18, end: 8)
                    : const EdgeInsetsDirectional.only(start: 18, end: 12),
                child: Row(
                  children: [
                    if (leading != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        child: SizedBox.square(
                          dimension: 16,
                          child: leading,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: contentPadding,
                        child: title,
                      ),
                    ),
                    Row(
                      children: [
                        if (trailing != null) trailing!,
                        if (tileType == SettingsTileType.switchTile)
                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: initialValue ?? false,
                              activeColor: activeSwitchColor,
                              onChanged: onToggle,
                            ),
                          ),
                        if (tileType == SettingsTileType.navigationTile &&
                            value != null)
                          DefaultTextStyle(
                            style: const TextStyle(fontSize: 17),
                            child: value!,
                          ),
                        if (tileType == SettingsTileType.navigationTile)
                          const Padding(
                            padding: EdgeInsetsDirectional.only(start: 6),
                            child: Icon(
                              CupertinoIcons.chevron_forward,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (needToShowDivider)
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 18, end: 12),
            child: CustomPaint(
              painter: DividerPainter(
                dashWidth: 5,
                dashSpace: 5,
              ),
              child: SizedBox(height: 1, width: double.infinity),
            ),
          ),
      ],
    );
  }
}

class DividerPainter extends CustomPainter {
  const DividerPainter({
    required this.dashWidth,
    required this.dashSpace,
  });
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is DividerPainter) {
      return oldDelegate.dashWidth != dashWidth ||
          oldDelegate.dashSpace != dashSpace;
    }
    return true;
  }
}
''';
  }
}
