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
  });
  final bool isLoading;
  final LifecycleState appLifecycleState;
  final ThemeMode themeMode;
  @override
  List<Object> get props => [isLoading, appLifecycleState, themeMode];

  CommonState copyWith({
    bool? isLoading,
    LifecycleState? appLifecycleState,
    ThemeMode? themeMode,
  }) {
    return CommonState(
      isLoading: isLoading ?? this.isLoading,
      appLifecycleState: appLifecycleState ?? this.appLifecycleState,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

''';
  }
}
