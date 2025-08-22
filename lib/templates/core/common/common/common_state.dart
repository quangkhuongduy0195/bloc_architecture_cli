class CommonStateGenerator {
  static String gen() {
    return '''part of 'common_bloc.dart';

enum LifecycleState {
  none,
  resumed,
  suspended,
}

class CommonState extends BaseState {
  const CommonState({
    this.isLoading = false,
    this.appLifecycleState = LifecycleState.none,
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
  });
  final bool isLoading;
  final LifecycleState appLifecycleState;
  final ThemeMode themeMode;
  final Locale locale;
  @override
  List<Object> get props => [isLoading, appLifecycleState, themeMode, locale];

  CommonState copyWith({
    bool? isLoading,
    LifecycleState? appLifecycleState,
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return CommonState(
      isLoading: isLoading ?? this.isLoading,
      appLifecycleState: appLifecycleState ?? this.appLifecycleState,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}


''';
  }
}
