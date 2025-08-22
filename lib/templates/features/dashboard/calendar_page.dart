class CalendarPageGenerator {
  static String gen() {
    return '''import '../../core/config.dart';

@RoutePage(name: 'CalendarRoute')
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l10n.navigatorCalendar),
    );
  }
}
''';
  }
}
