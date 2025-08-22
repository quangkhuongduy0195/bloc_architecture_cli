class CommonBlocGenerator {
  static String gen() {
    return '''import 'package:injectable/injectable.dart';

import '../../config.dart';
import '../base/base_bloc.dart';
import '../base/base_event.dart';
import '../base/base_state.dart';
import '../base/mixin/persisted_mixin.dart';

part 'common_event.dart';
part 'common_state.dart';

const kThemeModeKey = 'ff_theme_mode';

@LazySingleton()
class CommonBloc extends BaseBloc<CommonEvent, CommonState> {
  CommonBloc() : super(const CommonState()) {
    on<CommonInitial>(_onInitial);
    on<LoadingVisibility>(_onLoadingVisibility);
    on<AppLifecycleEvent>(_onAppLifecycle);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onInitial(
    CommonInitial event,
    Emitter<CommonState> emit,
  ) async {
    final themeMode = await PersistedStateMixin.read(kThemeModeKey);
    switch (themeMode) {
      case 'light':
        emit(state.copyWith(themeMode: ThemeMode.light));
        break;
      case 'dark':
        emit(state.copyWith(themeMode: ThemeMode.dark));
        break;
      default:
        emit(state.copyWith(themeMode: ThemeMode.system));
        break;
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<CommonState> emit,
  ) async {
    // await PersistedStateMixin.write(
    //     'ff_language', event.newLocale.languageCode);
    emit(state.copyWith(locale: event.newLocale));
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<CommonState> emit,
  ) async {
    final themeMode = switch (state.themeMode) {
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.dark,
    };

    await PersistedStateMixin.write(kThemeModeKey, themeMode.name);
    emit(state.copyWith(themeMode: themeMode));
  }

  void _onLoadingVisibility(
    LoadingVisibility event,
    Emitter<CommonState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onAppLifecycle(
    AppLifecycleEvent event,
    Emitter<CommonState> emit,
  ) {
    emit(state.copyWith(appLifecycleState: event.lifecycleState));
  }
}

''';
  }
}
