class DashboardPageGenerator {
  static String gen() {
    return '''import 'package:auto_route/auto_route.dart';

import 'package:flutter_svg/svg.dart';

import '../../core/config.dart';
import '../../core/routes/app_routes.gr.dart';
import '../../widgets/shader_mask.dart';

class BottomBar {
  BottomBar({required this.title, required this.icon});
  final String title;
  final String icon;
}

/// The dashboard screen.
///
/// This screen displays a list of users.
@RoutePage(name: 'DashboardRoute')
class DashboardScreen extends HookWidget {
  /// Creates a new instance of [DashboardScreen].
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottoms = [
      BottomBar(
        title: LocaleKeys.navigatorHome,
        icon: Assets.navigatorHome.path,
      ),
      BottomBar(
        title: LocaleKeys.navigatorCalendar,
        icon: Assets.navigatorCalendar.path,
      ),
      BottomBar(
        title: LocaleKeys.navigatorChart,
        icon: Assets.navigatorChart.path,
      ),
      BottomBar(
        title: LocaleKeys.navigatorTime,
        icon: Assets.navigatorTime.path,
      ),
      BottomBar(
        title: LocaleKeys.navigatorSettings,
        icon: Assets.navigatorSettings.path,
      ),
    ];
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        CalendarRoute(),
        ChartRoute(),
        TimeRoute(),
        SettingRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          body: child,
          bottomNavigationBar: AnimatedBuilder(
            animation: tabsRouter,
            builder: (_, __) => BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              selectedFontSize: 12,
              selectedItemColor: context.colorScheme.primary,
              items: bottoms.asMap().entries.map((e) {
                final index = e.key;
                final bottom = e.value;
                return BottomNavigationBarItem(
                  icon: ShaderMaskWidget(
                    colors: [primary, primaryVariant],
                    child: SvgPicture.asset(bottom.icon),
                  ),
                  label: context.tr(bottom.title),
                );
              }).toList(),
              onTap: tabsRouter.setActiveIndex,
              currentIndex: tabsRouter.activeIndex,
            ),
          ),
        );
      },
    );
  }
}
''';
  }
}
