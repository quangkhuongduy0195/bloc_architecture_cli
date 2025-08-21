class AppBlocObserverGenerator {
  static String gen() {
    return '''import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    Logger.log('Bloc Created: \${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    Logger.log('Event Added: \${bloc.runtimeType}, Event: \$event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    Logger.log(
      'State Changed: \${bloc.runtimeType}, State: \${change.currentState.runtimeType}',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    Logger.log(
      'Transition: \${bloc.runtimeType}, Event: \${transition.event}, State: \${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    Logger.log(
      'Error: \${bloc.runtimeType}, Error: \$error, StackTrace: \$stackTrace',
    );
  }
}

''';
  }
}
