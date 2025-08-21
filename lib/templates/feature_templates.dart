class FeatureTemplates {
  static String generateEntity(String className) {
    return '''import 'package:equatable/equatable.dart';

class ${className}Entity extends Equatable {
  final int id;
  final String name;
  final DateTime createdAt;

  const ${className}Entity({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, name, createdAt];
}
''';
  }

  static String generateRepository(String className) {
    return '''import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/${className.toLowerCase()}_entity.dart';

abstract class ${className}Repository {
  Future<Either<Failure, List<${className}Entity>>> get${className}s();
  Future<Either<Failure, ${className}Entity>> get${className}(int id);
  Future<Either<Failure, ${className}Entity>> create${className}(${className}Entity entity);
  Future<Either<Failure, ${className}Entity>> update${className}(${className}Entity entity);
  Future<Either<Failure, void>> delete${className}(int id);
}
''';
  }

  static String generateUseCase(String className, String fileName) {
    return '''import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/${fileName}_entity.dart';
import '../repositories/${fileName}_repository.dart';

class Get${className} implements UseCase<${className}Entity, Get${className}Params> {
  final ${className}Repository repository;

  Get${className}(this.repository);

  @override
  Future<Either<Failure, ${className}Entity>> call(Get${className}Params params) async {
    return await repository.get${className}(params.id);
  }
}

class Get${className}Params {
  final int id;

  Get${className}Params({required this.id});
}

class Get${className}s implements UseCase<List<${className}Entity>, NoParams> {
  final ${className}Repository repository;

  Get${className}s(this.repository);

  @override
  Future<Either<Failure, List<${className}Entity>>> call(NoParams params) async {
    return await repository.get${className}s();
  }
}
''';
  }

  static String generateModel(String className, String fileName) {
    return '''import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/${fileName}_entity.dart';

part '${fileName}_model.g.dart';

@JsonSerializable()
class ${className}Model extends ${className}Entity {
  const ${className}Model({
    required super.id,
    required super.name,
    required super.createdAt,
  });

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      _\$${className}ModelFromJson(json);

  Map<String, dynamic> toJson() => _\$${className}ModelToJson(this);

  factory ${className}Model.fromEntity(${className}Entity entity) {
    return ${className}Model(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
    );
  }

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
    return '''import '../../../core/network/api_client.dart';
import '../models/${fileName}_model.dart';

abstract class ${className}RemoteDataSource {
  Future<List<${className}Model>> get${className}s();
  Future<${className}Model> get${className}(int id);
  Future<${className}Model> create${className}(${className}Model model);
  Future<${className}Model> update${className}(${className}Model model);
  Future<void> delete${className}(int id);
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  final ApiClient apiClient;

  ${className}RemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<${className}Model>> get${className}s() async {
    try {
      final response = await apiClient.getData(); // Replace with actual endpoint
      return (response['data'] as List)
          .map((json) => ${className}Model.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<${className}Model> get${className}(int id) async {
    try {
      final response = await apiClient.getData(); // Replace with actual endpoint
      return ${className}Model.fromJson(response);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<${className}Model> create${className}(${className}Model model) async {
    try {
      final response = await apiClient.getData(); // Replace with actual endpoint
      return ${className}Model.fromJson(response);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<${className}Model> update${className}(${className}Model model) async {
    try {
      final response = await apiClient.getData(); // Replace with actual endpoint
      return ${className}Model.fromJson(response);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> delete${className}(int id) async {
    try {
      await apiClient.getData(); // Replace with actual endpoint
    } catch (e) {
      throw ServerException();
    }
  }
}
''';
  }

  static String generateLocalDataSource(String className, String fileName) {
    return '''import 'dart:convert';
import '../../../core/storage/local_storage.dart';
import '../../../core/error/exceptions.dart';
import '../models/${fileName}_model.dart';

abstract class ${className}LocalDataSource {
  Future<List<${className}Model>> getCached${className}s();
  Future<${className}Model> getCached${className}(int id);
  Future<void> cache${className}s(List<${className}Model> models);
  Future<void> cache${className}(${className}Model model);
  Future<void> remove${className}(int id);
  Future<void> clearCache();
}

class ${className}LocalDataSourceImpl implements ${className}LocalDataSource {
  final LocalStorage localStorage;
  static const String _cachedKey = 'cached_${fileName}s';

  ${className}LocalDataSourceImpl({required this.localStorage});

  @override
  Future<List<${className}Model>> getCached${className}s() async {
    try {
      final jsonString = await localStorage.getString(_cachedKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => ${className}Model.fromJson(json)).toList();
      }
      throw CacheException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<${className}Model> getCached${className}(int id) async {
    try {
      final models = await getCached${className}s();
      return models.firstWhere((model) => model.id == id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cache${className}s(List<${className}Model> models) async {
    try {
      final jsonString = json.encode(models.map((model) => model.toJson()).toList());
      await localStorage.setString(_cachedKey, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cache${className}(${className}Model model) async {
    try {
      final models = await getCached${className}s();
      final index = models.indexWhere((m) => m.id == model.id);
      if (index != -1) {
        models[index] = model;
      } else {
        models.add(model);
      }
      await cache${className}s(models);
    } catch (e) {
      // If no cached data exists, create new cache
      await cache${className}s([model]);
    }
  }

  @override
  Future<void> remove${className}(int id) async {
    try {
      final models = await getCached${className}s();
      models.removeWhere((model) => model.id == id);
      await cache${className}s(models);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await localStorage.remove(_cachedKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
''';
  }

  static String generateRepositoryImpl(String className, String fileName) {
    return '''import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/${fileName}_entity.dart';
import '../../domain/repositories/${fileName}_repository.dart';
import '../datasources/${fileName}_remote_datasource.dart';
import '../datasources/${fileName}_local_datasource.dart';
import '../models/${fileName}_model.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;
  final ${className}LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ${className}RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<${className}Entity>>> get${className}s() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.get${className}s();
        await localDataSource.cache${className}s(remoteData);
        return Right(remoteData.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData = await localDataSource.getCached${className}s();
        return Right(localData.map((model) => model.toEntity()).toList());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ${className}Entity>> get${className}(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.get${className}(id);
        await localDataSource.cache${className}(remoteData);
        return Right(remoteData.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData = await localDataSource.getCached${className}(id);
        return Right(localData.toEntity());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ${className}Entity>> create${className}(${className}Entity entity) async {
    try {
      final model = ${className}Model.fromEntity(entity);
      final createdData = await remoteDataSource.create${className}(model);
      await localDataSource.cache${className}(createdData);
      return Right(createdData.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ${className}Entity>> update${className}(${className}Entity entity) async {
    try {
      final model = ${className}Model.fromEntity(entity);
      final updatedData = await remoteDataSource.update${className}(model);
      await localDataSource.cache${className}(updatedData);
      return Right(updatedData.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete${className}(int id) async {
    try {
      await remoteDataSource.delete${className}(id);
      await localDataSource.remove${className}(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
''';
  }

  static String generateController(String className, String fileName) {
    return '''import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/usecases/usecase.dart';
import '../../domain/entities/${fileName}_entity.dart';
import '../../domain/usecases/get_${fileName}.dart';

part '${fileName}_state.dart';

class ${className}Cubit extends Cubit<${className}State> {
  final Get${className}s get${className}s;
  final Get${className} get${className};

  ${className}Cubit({
    required this.get${className}s,
    required this.get${className},
  }) : super(${className}Initial());

  Future<void> load${className}s() async {
    emit(${className}Loading());
    
    final result = await get${className}s(NoParams());
    
    result.fold(
      (failure) => emit(${className}Error(_mapFailureToMessage(failure))),
      (data) => emit(${className}Loaded(data)),
    );
  }

  Future<void> load${className}(int id) async {
    emit(${className}Loading());
    
    final result = await get${className}(Get${className}Params(id: id));
    
    result.fold(
      (failure) => emit(${className}Error(_mapFailureToMessage(failure))),
      (data) => emit(${className}DetailLoaded(data)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
''';
  }

  static String generateScreen(String className, String fileName) {
    return '''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/${fileName}_controller.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${className}Cubit(
        get${className}s: getIt(),
        get${className}: getIt(),
      )..load${className}s(),
      child: const ${className}View(),
    );
  }
}

class ${className}View extends StatelessWidget {
  const ${className}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${className}s'),
      ),
      body: BlocBuilder<${className}Cubit, ${className}State>(
        builder: (context, state) {
          if (state is ${className}Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ${className}Loaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('ID: \${item.id}'),
                  onTap: () {
                    context.read<${className}Cubit>().load${className}(item.id);
                  },
                );
              },
            );
          } else if (state is ${className}DetailLoaded) {
            final item = state.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('ID: \${item.id}'),
                  const SizedBox(height: 8),
                  Text('Created: \${item.createdAt}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<${className}Cubit>().load${className}s();
                    },
                    child: const Text('Back to List'),
                  ),
                ],
              ),
            );
          } else if (state is ${className}Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<${className}Cubit>().load${className}s();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Welcome to ${className} Feature'));
        },
      ),
    );
  }
}
''';
  }

  static String generateWidget(String className, String fileName) {
    return '''import 'package:flutter/material.dart';

class ${className}Widget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const ${className}Widget({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'This is a ${className} widget',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }
}
