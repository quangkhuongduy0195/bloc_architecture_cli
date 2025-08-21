class CalendarPageGenerator {
  static String gen() {
    return '''import 'package:flutter/material.dart';

import '../../core/config.dart';

@RoutePage(name: 'CalendarRoute')
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.tr(LocaleKeys.navigatorCalendar)),
    );
  }
}
''';
  }
}
