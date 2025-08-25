class FeatureTemplates {
  static String generateEntity(String className, String fileName) {
    return '''import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../data/models/${fileName}_model.dart';

class ${className}Entity extends Equatable {

  const ${className}Entity({this.id, this.name, this.createdAt});
  final int? id;
  final String? name;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, name, createdAt];

  FutureOr<${className}Model> toModel() {
    return ${className}Model(id: id, name: name, createdAt: createdAt);
  }
}

''';
  }

  static String generateRepository(String className, String fileName) {
    return '''import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../data/models/${fileName}_model.dart';

abstract class ${className}Repository {
  const ${className}Repository();
  Future<Either<AppException, ${className}Model>> get${className}();
}

''';
  }

  static String generateUseCase(String className, String fileName) {
    return '''import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/${fileName}_model.dart';
import '../repositories/${fileName}_repository.dart';

@Injectable()
class Get${className}
    implements UsecaseWithoutFuture<Either<AppException, ${className}Model>> {
  Get${className}(this.repository);
  final ${className}Repository repository;

  @override
  Future<Either<AppException, ${className}Model>> call() {
    return repository.get${className}();
  }
}

class Get${className}Params {
  Get${className}Params({required this.id});
  final int id;
}

''';
  }

  static String generateModel(String className, String fileName) {
    return '''import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/${fileName}_entity.dart';

part '${fileName}_model.g.dart';

@JsonSerializable()
class ${className}Model extends ${className}Entity {
  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      _\$${className}ModelFromJson(json);
      
  factory ${className}Model.createFromEntity(${className}Entity entity) {
    return ${className}Model(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
    );
  }

  factory ${className}Model.fromEntity(${className}Entity entity) {
    return ${className}Model(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
    );
  }

  const ${className}Model({
    super.id,
    super.name,
    super.createdAt,
  });

  Map<String, dynamic> toJson() => _\$${className}ModelToJson(this);

  ${className}Entity toEntity() {
    return ${className}Entity(
      id: id,
      name: name,
      createdAt: createdAt,
    );
  }
}
''';
  }

  static String generateRemoteDataSource(String className, String fileName) {
    return '''import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/base/mixin/api_error_handler_mixin.dart';
import '../../../../core/errors/exception.dart';

import '../../domain/services/${fileName}_service.dart';
import '../models/${fileName}_model.dart';

@Injectable()
class ${className}RemoteDataSource with ApiHandlerMixin {
  ${className}RemoteDataSource(this.service);
  final ${className}Service service;

  Future<Either<AppException, ${className}Model>> get${className}() async {
    try {
      final response = await service.get${className}();
      return Right(response);
    } catch (e) {
      return Left(ServerException());
    }
  }
}

''';
  }

  static String generateLocalDataSource(String className, String fileName) {
    return '''import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../core/common/base/mixin/persisted_mixin.dart';
import '../models/${fileName}_model.dart';

@Injectable()
class ${className}LocalDataSource with PersistedStateMixin<${className}Model> {
  const ${className}LocalDataSource();

  @override
  String get cacheKey => 'cached_${fileName}s';

  Future<${className}Model?> getCache() => load();

  @override
  FutureOr<${className}Model> fromJson(Map<String, dynamic> json) {
    return ${className}Model.fromJson(json);
  }
}


''';
  }

  static String generateRepositoryImpl(String className, String fileName) {
    return '''import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/repositories/${fileName}_repository.dart';
import '../datasources/${fileName}_local_datasource.dart';
import '../datasources/${fileName}_remote_datasource.dart';
import '../models/${fileName}_model.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  ${className}RepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.connectionChecker,
  );
  final ${className}RemoteDataSource remoteDataSource;
  final ${className}LocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  @override
  Future<Either<AppException, ${className}Model>> get${className}() async {
    if (await connectionChecker.isConnected) {
      final remoteResult = await remoteDataSource.get${className}();
      return remoteResult.fold((exception) => Left(exception), (result) async {
        return Right(result);
      });
    } else {
      return Left(NetworkException());
    }
  }
}

''';
  }

  static String generateBloc(String className, String fileName) {
    return '''import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/common/base/base_bloc.dart';
import '../../../../core/common/base/base_event.dart';
import '../../../../core/common/base/base_state.dart';
import '../../domain/entities/${fileName}_entity.dart';
import '../../domain/usecases/get_${fileName}.dart';

part '${fileName}_state.dart';
part '${fileName}_event.dart';

@LazySingleton()
class ${className}Bloc extends BaseBloc<${className}Event, ${className}State> {
  ${className}Bloc({required Get${className} get${className}})
    : _get${className} = get${className},
      super(${className}Initial()) {
    on<${className}Requested>((event, emit) => _on${className}Requested(event, emit));
  }

  final Get${className} _get${className};

  Future<void> _on${className}Requested(
    ${className}Requested event,
    Emitter<${className}State> emit,
  ) async {
    startLoading();
    final result = await _get${className}.call();
    stopLoading();
    result.fold(
      (failure) => emit(${className}Failure(failure.message)),
      (signUpEntity) => emit(${className}Success(signUpEntity)),
    );
  }
}

''';
  }

  static String generateState(String className, String fileName) {
    return '''part of '${fileName}_bloc.dart';

sealed class ${className}State extends BaseState {
  const ${className}State();
}

class ${className}Initial extends ${className}State {
  const ${className}Initial();
}

class ${className}Success extends ${className}State {
  const ${className}Success(this.${fileName}Entity);
  final ${className}Entity ${fileName}Entity;
}

class ${className}Failure extends ${className}State {
  const ${className}Failure(this.message);
  final String message;
}

''';
  }

  static String generateEvent(String className, String fileName) {
    return '''part of '${fileName}_bloc.dart';

sealed class ${className}Event extends BaseEvent {
  const ${className}Event();
}

class ${className}Requested extends ${className}Event {
  const ${className}Requested();

  @override
  List<Object> get props => [];
}
''';
  }

  static String generatePage(String className, String fileName) {
    return '''import '../../../../core/config.dart';
import '../../../../di/injection.dart';
import '../bloc/${fileName}_bloc.dart';

@RoutePage(name: '${className}Route')
class ${className}Page extends StatefulHookWidget {
  const ${className}Page({super.key});

  @override
  State<StatefulWidget> createState() => _${className}PageState();
}

class _${className}PageState extends State<${className}Page> {
  final bloc = getIt<${className}Bloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocProvider<${className}Bloc>(
        create: (context) => bloc,
        child: const ${className}View(),
      ),
    );
  }
}

class ${className}View extends StatelessWidget {
  const ${className}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${className}s')),
      body: BlocBuilder<${className}Bloc, ${className}State>(
        builder: (context, state) {
          return const Center(child: Text('Welcome to ${className} Feature'));
        },
      ),
    );
  }
}

''';
  }

  static String generateWidget(String className, String fileName) {
    return '';
  }

  static String generateService(String className, String fileName) {
    return '''import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/${fileName}_model.dart';

part '${fileName}_service.g.dart';

@RestApi()
abstract class ${className}Service {
  factory ${className}Service(Dio dio, {String? baseUrl}) = _${className}Service;

  @GET('/api/${fileName}')
  Future<${className}Model> get${className}();
}
''';
  }
}
