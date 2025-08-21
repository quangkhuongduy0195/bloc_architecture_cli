class ComponentTemplates {
  static String generateModel(String className) {
    return '''import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part '${className.toLowerCase()}_model.g.dart';

@JsonSerializable()
class ${className}Model extends Equatable {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ${className}Model({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      _\$${className}ModelFromJson(json);

  Map<String, dynamic> toJson() => _\$${className}ModelToJson(this);

  ${className}Model copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ${className}Model(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [id, name, createdAt, updatedAt];
}
''';
  }

  static String generateRepositoryInterface(String className) {
    return '''import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../models/${className.toLowerCase()}_model.dart';

abstract class ${className}Repository {
  Future<Either<Failure, List<${className}Model>>> getAll();
  Future<Either<Failure, ${className}Model>> getById(int id);
  Future<Either<Failure, ${className}Model>> create(${className}Model model);
  Future<Either<Failure, ${className}Model>> update(${className}Model model);
  Future<Either<Failure, void>> delete(int id);
}
''';
  }

  static String generateRepositoryImplementation(String className, String fileName) {
    return '''import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../error/exceptions.dart';
import '../models/${fileName}_model.dart';
import '${fileName}_repository.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  // Add your data sources here
  // final ${className}RemoteDataSource remoteDataSource;
  // final ${className}LocalDataSource localDataSource;

  const ${className}RepositoryImpl({
    // required this.remoteDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<${className}Model>>> getAll() async {
    try {
      // Implement your logic here
      final List<${className}Model> models = [];
      return Right(models);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ${className}Model>> getById(int id) async {
    try {
      // Implement your logic here
      final model = ${className}Model(
        id: id,
        name: 'Sample ${className}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return Right(model);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ${className}Model>> create(${className}Model model) async {
    try {
      // Implement your logic here
      return Right(model);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ${className}Model>> update(${className}Model model) async {
    try {
      // Implement your logic here
      return Right(model);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      // Implement your logic here
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
''';
  }

  static String generateUseCase(String className, String fileName) {
    return '''import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../usecases/usecase.dart';
import '../models/${fileName}_model.dart';
import '../repositories/${fileName}_repository.dart';

class ${className}UseCase implements UseCase<${className}Model, ${className}Params> {
  final ${className}Repository repository;

  ${className}UseCase(this.repository);

  @override
  Future<Either<Failure, ${className}Model>> call(${className}Params params) async {
    return await repository.getById(params.id);
  }
}

class ${className}Params {
  final int id;

  ${className}Params({required this.id});
}
''';
  }

  static String generateController(String className, String fileName) {
    return '''import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/${fileName}_model.dart';
import '../usecases/${fileName}_usecase.dart';

part '${fileName}_state.dart';

class ${className}Controller extends Cubit<${className}State> {
  final ${className}UseCase useCase;

  ${className}Controller({required this.useCase}) : super(${className}Initial());

  Future<void> load${className}(int id) async {
    emit(${className}Loading());
    
    final result = await useCase(${className}Params(id: id));
    
    result.fold(
      (failure) => emit(${className}Error(_mapFailureToMessage(failure))),
      (data) => emit(${className}Loaded(data)),
    );
  }

  void reset() {
    emit(${className}Initial());
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
      create: (context) => ${className}Controller(useCase: getIt()),
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
        title: const Text('${className}'),
      ),
      body: BlocBuilder<${className}Controller, ${className}State>(
        builder: (context, state) {
          if (state is ${className}Initial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<${className}Controller>().load${className}(1);
                },
                child: const Text('Load ${className}'),
              ),
            );
          } else if (state is ${className}Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ${className}Loaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.data.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('ID: \${state.data.id}'),
                  const SizedBox(height: 8),
                  Text('Created: \${state.data.createdAt}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<${className}Controller>().reset();
                    },
                    child: const Text('Reset'),
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
                      context.read<${className}Controller>().load${className}(1);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
''';
  }

  static String generateWidget(String className) {
    return '''import 'package:flutter/material.dart';

class ${className}Widget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const ${className}Widget({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }

  static String generateService(String className) {
    return '''import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../models/${className.toLowerCase()}_model.dart';

abstract class ${className}Service {
  Future<Either<Failure, List<${className}Model>>> getAll();
  Future<Either<Failure, ${className}Model>> getById(int id);
  Future<Either<Failure, ${className}Model>> create(${className}Model model);
  Future<Either<Failure, ${className}Model>> update(${className}Model model);
  Future<Either<Failure, void>> delete(int id);
}

class ${className}ServiceImpl implements ${className}Service {
  // Add dependencies here if needed
  
  const ${className}ServiceImpl();

  @override
  Future<Either<Failure, List<${className}Model>>> getAll() async {
    try {
      // Implement your business logic here
      final List<${className}Model> models = [];
      return Right(models);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ${className}Model>> getById(int id) async {
    try {
      // Implement your business logic here
      final model = ${className}Model(
        id: id,
        name: 'Sample ${className}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ${className}Model>> create(${className}Model model) async {
    try {
      // Implement your business logic here
      return Right(model);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ${className}Model>> update(${className}Model model) async {
    try {
      // Implement your business logic here
      return Right(model);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      // Implement your business logic here
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
''';
  }
}
