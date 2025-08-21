class WidgetThemeModeGenerator {
  static String gen() {
    return '''import '../core/common/common/common_bloc.dart';
import '../core/config.dart';

class ThemeModeToggle extends HookWidget {
  const ThemeModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final icon = Theme.of(context).brightness == Brightness.light
        ? Icons.dark_mode
        : Icons.light_mode;

    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        context.read<CommonBloc>().add(const ThemeModeChanged());
      },
    );
  }
}

''';
  }
}
