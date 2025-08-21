class AppRoutesGenerator {
  /// Generates the code for the app routes.
  static String gen() {
    return '''

import '../../di/injection.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../config.dart';
import 'app_routes.gr.dart';

final globalKey = GlobalKey<NavigatorState>();

final appRouter = AppRouter();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  String? previousRoute;

  @override
  final List<AutoRoute> routes = [
    CustomRoute(
      page: LoginRoute.page,
      path: '/login',
      transitionsBuilder: customAnimation,
    ),
    CustomRoute(
      initial: true,
      path: '/dashboard',
      page: DashboardRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
      children: [
        RedirectRoute(path: '', redirectTo: 'home'),
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: SettingRoute.page, path: 'setting'),
        AutoRoute(page: ChartRoute.page, path: 'chart'),
        AutoRoute(page: CalendarRoute.page, path: 'calendar'),
        AutoRoute(page: TimeRoute.page, path: 'time'),
      ],
    ),
  ];
  @override
  late final List<AutoRouteGuard> guards = [const AuthGuard()];
}

@RoutePage(name: 'HomeNavRoute')
class HomeNav extends AutoRouter {
  const HomeNav({super.key});
}

@RoutePage(name: 'ChartNavRoute')
class ChartNav extends AutoRouter {
  const ChartNav({super.key});
}

@RoutePage(name: 'CalendarNavRoute')
class CalendarNav extends AutoRouter {
  const CalendarNav({super.key});
}

@RoutePage(name: 'SettingNavRoute')
class SettingNav extends AutoRouter {
  const SettingNav({super.key});
}

class AuthGuard extends AutoRouteGuard {
  const AuthGuard();
  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    final isLoginIn = await getIt<AuthBloc>().authCheck.future;

    /// List of routes that do not require authentication
    final acceptRoutes = [
      LoginRoute.name,
    ];

    /// check if route is login
    if (isLoginIn || acceptRoutes.contains(resolver.route.name)) {
      resolver.next();
    } else {
      resolver.redirectUntil(
        LoginRoute(onResult: (didLogin) => resolver.next(didLogin)),
      );
    }
  }
}

Widget customAnimation(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation.drive(CurveTween(curve: Curves.easeInOutQuart)),
    child: ScaleTransition(
      scale: Tween<double>(begin: 1.1, end: 1).animate(animation),
      child: child,
    ),
  );
}
''';
  }
}
