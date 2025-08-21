class WidgetShaderMaskGenerator {
  static String gen() {
    return '''

import '../../core/config.dart';

class ShaderMaskWidget extends StatelessWidget {
  const ShaderMaskWidget({
    super.key,
    required this.child,
    this.colors = const [primary, primaryVariant],
    this.blendMode = BlendMode.srcIn,
  });

  final Widget child;

  final List<Color> colors;

  final BlendMode blendMode;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(colors: colors).createShader(bounds);
      },
      blendMode: blendMode,
      child: SizedBox.square(
        dimension: 24,
        child: child,
      ),
    );
  }
}
''';
  }
}
