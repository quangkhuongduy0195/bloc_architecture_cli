class CommonEventGenerator {
  static String gen() {
    return '''part of 'common_bloc.dart';

sealed class CommonEvent extends BaseEvent {
  const CommonEvent();
}

class CommonInitial extends CommonEvent {
  const CommonInitial();
}

class LoadingVisibility extends CommonEvent {
  const LoadingVisibility(this.isLoading);
  final bool isLoading;
}

class AppLifecycleEvent extends CommonEvent {
  const AppLifecycleEvent(this.lifecycleState);
  final LifecycleState lifecycleState;
}

class ThemeModeChanged extends CommonEvent {
  const ThemeModeChanged();
}

class ChangeLanguage extends CommonEvent {
  const ChangeLanguage(this.newLocale);
  final Locale newLocale;

  @override
  List<Object> get props => [newLocale];
}

''';
  }
}
