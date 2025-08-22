class ChartPageGenerator {
  static String gen() {
    return '''import '../../core/config.dart';

@RoutePage(name: 'ChartRoute')
class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l10n.navigatorChart),
    );
  }
}

''';
  }
}
