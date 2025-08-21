// class ProjectTemplates {
//   static String generatePubspec(String projectName) {
//     return '''name: $projectName
// description: A new Flutter project with clean architecture.
// publish_to: 'none'
// version: 1.0.0+1

// environment:
//   sdk: '>=3.0.0 <4.0.0'
//   flutter: ">=1.17.0"

// dependencies:
//   flutter:
//     sdk: flutter
  
//   # State Management
//   flutter_bloc: ^8.1.3
//   get_it: ^7.6.4
//   injectable: ^2.3.2
  
//   # Network
//   dio: ^5.3.2
//   retrofit: ^4.0.3
//   json_annotation: ^4.8.1
  
//   # Local Storage
//   shared_preferences: ^2.2.2
//   hive: ^2.2.3
//   hive_flutter: ^1.1.0
  
//   # Utils
//   equatable: ^2.0.5
//   dartz: ^0.10.1
//   intl: ^0.18.1
  
//   # UI
//   cached_network_image: ^3.3.0
//   flutter_svg: ^2.0.9

// dev_dependencies:
//   flutter_test:
//     sdk: flutter
//   flutter_lints: ^3.0.0
  
//   # Code Gene  }
// }
// ''';
//   }

//   static String generateExampleRemoteDataSource() {
//     return '''import '../../../core/network/api_client.dart';
// import '../../../core/error/exceptions.dart';
// import '../models/example_model.dart';

// abstract class ExampleRemoteDataSource {
//   Future<List<ExampleModel>> getExamples();
//   Future<ExampleModel> getExample(int id);
//   Future<ExampleModel> createExample(ExampleModel model);
//   Future<ExampleModel> updateExample(ExampleModel model);
//   Future<void> deleteExample(int id);
// }

// class ExampleRemoteDataSourceImpl implements ExampleRemoteDataSource {
//   final ApiClient apiClient;

//   ExampleRemoteDataSourceImpl({required this.apiClient});

//   @override
//   Future<List<ExampleModel>> getExamples() async {
//     try {
//       final response = await apiClient.getData();
//       return (response['data'] as List)
//           .map((json) => ExampleModel.fromJson(json))
//           .toList();
//     } catch (e) {
//       throw ServerException();
//     }
//   }

//   @override
//   Future<ExampleModel> getExample(int id) async {
//     try {
//       final response = await apiClient.getData();
//       return ExampleModel.fromJson(response);
//     } catch (e) {
//       throw ServerException();
//     }
//   }

//   @override
//   Future<ExampleModel> createExample(ExampleModel model) async {
//     try {
//       final response = await apiClient.getData();
//       return ExampleModel.fromJson(response);
//     } catch (e) {
//       throw ServerException();
//     }
//   }

//   @override
//   Future<ExampleModel> updateExample(ExampleModel model) async {
//     try {
//       final response = await apiClient.getData();
//       return ExampleModel.fromJson(response);
//     } catch (e) {
//       throw ServerException();
//     }
//   }

//   @override
//   Future<void> deleteExample(int id) async {
//     try {
//       await apiClient.getData();
//     } catch (e) {
//       throw ServerException();
//     }
//   }
// }
// ''';
//   }

//   static String generateExampleLocalDataSource() {
//     return '''import 'dart:convert';
// import '../../../core/storage/local_storage.dart';
// import '../../../core/error/exceptions.dart';
// import '../models/example_model.dart';

// abstract class ExampleLocalDataSource {
//   Future<List<ExampleModel>> getCachedExamples();
//   Future<ExampleModel> getCachedExample(int id);
//   Future<void> cacheExamples(List<ExampleModel> models);
//   Future<void> cacheExample(ExampleModel model);
//   Future<void> removeExample(int id);
//   Future<void> clearCache();
// }

// class ExampleLocalDataSourceImpl implements ExampleLocalDataSource {
//   final LocalStorage localStorage;
//   static const String _cachedKey = 'cached_examples';

//   ExampleLocalDataSourceImpl({required this.localStorage});

//   @override
//   Future<List<ExampleModel>> getCachedExamples() async {
//     try {
//       final jsonString = await localStorage.getString(_cachedKey);
//       if (jsonString != null) {
//         final List<dynamic> jsonList = json.decode(jsonString);
//         return jsonList.map((json) => ExampleModel.fromJson(json)).toList();
//       }
//       throw CacheException();
//     } catch (e) {
//       throw CacheException();
//     }
//   }

//   @override
//   Future<ExampleModel> getCachedExample(int id) async {
//     try {
//       final models = await getCachedExamples();
//       return models.firstWhere((model) => model.id == id);
//     } catch (e) {
//       throw CacheException();
//     }
//   }

//   @override
//   Future<void> cacheExamples(List<ExampleModel> models) async {
//     try {
//       final jsonString = json.encode(models.map((model) => model.toJson()).toList());
//       await localStorage.setString(_cachedKey, jsonString);
//     } catch (e) {
//       throw CacheException();
//     }
//   }

//   @override
//   Future<void> cacheExample(ExampleModel model) async {
//     try {
//       final models = await getCachedExamples();
//       final index = models.indexWhere((m) => m.id == model.id);
//       if (index != -1) {
//         models[index] = model;
//       } else {
//         models.add(model);
//       }
//       await cacheExamples(models);
//     } catch (e) {
//       await cacheExamples([model]);
//     }
//   }

//   @override
//   Future<void> removeExample(int id) async {
//     try {
//       final models = await getCachedExamples();
//       models.removeWhere((model) => model.id == id);
//       await cacheExamples(models);
//     } catch (e) {
//       throw CacheException();
//     }
//   }

//   @override
//   Future<void> clearCache() async {
//     try {
//       await localStorage.remove(_cachedKey);
//     } catch (e) {
//       throw CacheException();
//     }
//   }
// }
// ''';
//   }

//   static String generateExampleController() {
//   build_runner: ^2.4.7
//   json_serializable: ^6.7.1
//   retrofit_generator: ^8.0.4
//   injectable_generator: ^2.4.1
//   hive_generator: ^2.0.1

// flutter:
//   uses-material-design: true
//   assets:
//     - assets/images/
//     - assets/icons/
//   fonts:
//     - family: Inter
//       fonts:
//         - asset: assets/fonts/Inter-Regular.ttf
//         - asset: assets/fonts/Inter-Medium.ttf
//           weight: 500
//         - asset: assets/fonts/Inter-SemiBold.ttf
//           weight: 600
//         - asset: assets/fonts/Inter-Bold.ttf
//           weight: 700
// ''';
//   }

//   static String generateMain() {
//     return '''import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'core/core.dart';
// import 'features/example/presentation/screens/example_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize dependencies
//   await initializeDependencies();
  
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Clean Architecture',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       home: const ExampleScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
// ''';
//   }

//   static String generateAnalysisOptions() {
//     return '''include: package:flutter_lints/flutter.yaml

// linter:
//   rules:
//     prefer_single_quotes: true
//     prefer_const_constructors: true
//     prefer_const_literals_to_create_immutables: true
//     avoid_unnecessary_containers: true
//     avoid_function_literals_in_foreach_calls: true
//     prefer_relative_imports: true
//     sort_constructors_first: true
//     sort_unnamed_constructors_first: true

// analyzer:
//   exclude:
//     - "**/*.g.dart"
//     - "**/*.freezed.dart"
//     - "**/*.gr.dart"
//     - "lib/gen/**"
// ''';
//   }

//   static String generateReadme(String projectName) {
//     return '''# $projectName

// A new Flutter project with clean architecture.

// ## Architecture

// This project follows Clean Architecture principles with the following structure:

// ```
// lib/
// |-- main.dart                     # Application entry point
// |-- core/                         # Core functionality
// |   |-- auth/                     # Authentication 
// |   |-- error/                    # Error handling
// |   |-- feature_flags/            # Feature flags
// |   |-- images/                   # Image utilities
// |   |-- l10n/                     # Localization
// |   |-- network/                  # Network handling
// |   |-- storage/                  # Local storage & caching
// |   |-- theme/                    # Theming
// |   |-- ui/                       # Shared UI components
// |   |-- utils/                    # Utility functions and extensions
// |   |-- updates/                  # App update handling
// |-- features/                     # Feature modules
// |   |-- feature_a/                # Example feature
// |   |   |-- data/                 # Data layer (repositories, data sources)
// |   |   |-- domain/               # Domain layer (entities, use cases)
// |   |   |-- presentation/         # UI layer (screens, widgets, controllers)
// |-- gen/                          # Generated code
// |-- l10n/                         # Localization resources
//     |-- arb/                      # ARB translation files
// ```

// ## Getting Started

// 1. Install dependencies:
// ```bash
// flutter pub get
// ```

// 2. Run code generation:
// ```bash
// flutter packages pub run build_runner build
// ```

// 3. Run the app:
// ```bash
// flutter run
// ```

// ## CLI Commands

// This project was generated using flutter_gen CLI. You can use the following commands:

// - Generate a new feature: `flutter_gen feature <feature_name>`
// - Generate components: `flutter_gen generate <type> <name>`

// Available component types:
// - model
// - repository
// - usecase
// - controller
// - screen
// - widget
// - service
// ''';
//   }

//   static String generateCoreBarrel() {
//     return '''// Core exports
// export 'error/error.dart';
// export 'network/network.dart';
// export 'storage/storage.dart';
// export 'theme/theme.dart';
// export 'utils/utils.dart';

// // Dependency injection
// import 'package:get_it/get_it.dart';
// import 'package:injectable/injectable.dart';

// final GetIt getIt = GetIt.instance;

// @InjectableInit()
// Future<void> initializeDependencies() async {
//   // Initialize dependencies here
//   // getIt.init();
// }
// ''';
//   }

//   static String generateApiClient() {
//     return '''import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';

// part 'api_client.g.dart';

// @RestApi(baseUrl: 'https://api.example.com')
// abstract class ApiClient {
//   factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

//   // Example API endpoint
//   @GET('/data')
//   Future<Map<String, dynamic>> getData();
// }

// class DioProvider {
//   static Dio getDio() {
//     final dio = Dio();
    
//     // Add interceptors
//     dio.interceptors.add(LogInterceptor(
//       requestBody: true,
//       responseBody: true,
//     ));
    
//     return dio;
//   }
// }
// ''';
//   }

//   static String generateNetworkInfo() {
//     return '''import 'package:connectivity_plus/connectivity_plus.dart';

// abstract class NetworkInfo {
//   Future<bool> get isConnected;
// }

// class NetworkInfoImpl implements NetworkInfo {
//   final Connectivity connectivity;

//   NetworkInfoImpl(this.connectivity);

//   @override
//   Future<bool> get isConnected async {
//     final result = await connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }
// }
// ''';
//   }

//   static String generateFailures() {
//     return '''import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {
//   const Failure();

//   @override
//   List<Object> get props => [];
// }

// // General failures
// class ServerFailure extends Failure {}

// class CacheFailure extends Failure {}

// class NetworkFailure extends Failure {}

// class ValidationFailure extends Failure {
//   final String message;

//   const ValidationFailure(this.message);

//   @override
//   List<Object> get props => [message];
// }
// ''';
//   }

//   static String generateExceptions() {
//     return '''class ServerException implements Exception {}

// class CacheException implements Exception {}

// class NetworkException implements Exception {}

// class ValidationException implements Exception {
//   final String message;

//   ValidationException(this.message);
// }
// ''';
//   }

//   static String generateExtensions() {
//     return '''extension StringExtensions on String {
//   String get capitalize {
//     return '\${this[0].toUpperCase()}\${substring(1)}';
//   }

//   bool get isEmail {
//     return RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(this);
//   }

//   bool get isPhoneNumber {
//     return RegExp(r'^[\\+]?[1-9]?[0-9]{7,12}\$').hasMatch(this);
//   }
// }

// extension ContextExtensions on BuildContext {
//   // Theme shortcuts
//   ThemeData get theme => Theme.of(this);
//   TextTheme get textTheme => Theme.of(this).textTheme;
//   ColorScheme get colorScheme => Theme.of(this).colorScheme;

//   // MediaQuery shortcuts
//   MediaQueryData get mediaQuery => MediaQuery.of(this);
//   Size get screenSize => MediaQuery.of(this).size;
//   double get screenWidth => MediaQuery.of(this).size.width;
//   double get screenHeight => MediaQuery.of(this).size.height;

//   // Navigation shortcuts
//   void pop<T>([T? result]) => Navigator.of(this).pop(result);
//   Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
//         MaterialPageRoute(builder: (_) => page),
//       );
// }

// extension DateTimeExtensions on DateTime {
//   String get formattedDate {
//     return '\${day.toString().padLeft(2, '0')}/\${month.toString().padLeft(2, '0')}/\$year';
//   }

//   bool get isToday {
//     final now = DateTime.now();
//     return year == now.year && month == now.month && day == now.day;
//   }
// }
// ''';
//   }

//   static String generateAppTheme() {
//     return '''import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color primaryColor = Color(0xFF2196F3);
//   static const Color secondaryColor = Color(0xFF03DAC6);
//   static const Color errorColor = Color(0xFFB00020);
//   static const Color surfaceColor = Color(0xFFFFFFFF);
//   static const Color backgroundColor = Color(0xFFF5F5F5);

//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: const ColorScheme.light(
//         primary: primaryColor,
//         secondary: secondaryColor,
//         error: errorColor,
//         surface: surfaceColor,
//         background: backgroundColor,
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: const ColorScheme.dark(
//         primary: primaryColor,
//         secondary: secondaryColor,
//         error: errorColor,
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Color(0xFF121212),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//     );
//   }
// }
// ''';
//   }

//   static String generateLocalStorage() {
//     return '''import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// abstract class LocalStorage {
//   Future<void> setString(String key, String value);
//   Future<String?> getString(String key);
//   Future<void> setBool(String key, bool value);
//   Future<bool?> getBool(String key);
//   Future<void> setInt(String key, int value);
//   Future<int?> getInt(String key);
//   Future<void> remove(String key);
//   Future<void> clear();
// }

// class LocalStorageImpl implements LocalStorage {
//   final SharedPreferences sharedPreferences;

//   LocalStorageImpl(this.sharedPreferences);

//   @override
//   Future<void> setString(String key, String value) async {
//     await sharedPreferences.setString(key, value);
//   }

//   @override
//   Future<String?> getString(String key) async {
//     return sharedPreferences.getString(key);
//   }

//   @override
//   Future<void> setBool(String key, bool value) async {
//     await sharedPreferences.setBool(key, value);
//   }

//   @override
//   Future<bool?> getBool(String key) async {
//     return sharedPreferences.getBool(key);
//   }

//   @override
//   Future<void> setInt(String key, int value) async {
//     await sharedPreferences.setInt(key, value);
//   }

//   @override
//   Future<int?> getInt(String key) async {
//     return sharedPreferences.getInt(key);
//   }

//   @override
//   Future<void> remove(String key) async {
//     await sharedPreferences.remove(key);
//   }

//   @override
//   Future<void> clear() async {
//     await sharedPreferences.clear();
//   }
// }

// class HiveService {
//   static Future<void> init() async {
//     await Hive.initFlutter();
//     // Register adapters here
//   }

//   static Box<T> getBox<T>(String boxName) {
//     return Hive.box<T>(boxName);
//   }

//   static Future<Box<T>> openBox<T>(String boxName) async {
//     return await Hive.openBox<T>(boxName);
//   }
// }
// ''';
//   }

//   static String generateUseCase() {
//     return '''import 'package:dartz/dartz.dart';
// import '../error/failures.dart';

// abstract class UseCase<Type, Params> {
//   Future<Either<Failure, Type>> call(Params params);
// }

// class NoParams {
//   const NoParams();
// }
// ''';
//   }

//   static String generateExampleEntity() {
//     return '''import 'package:equatable/equatable.dart';

// class ExampleEntity extends Equatable {
//   final int id;
//   final String title;
//   final String description;
//   final DateTime createdAt;

//   const ExampleEntity({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.createdAt,
//   });

//   @override
//   List<Object> get props => [id, title, description, createdAt];
// }
// ''';
//   }

//   static String generateExampleModel() {
//     return '''import 'package:json_annotation/json_annotation.dart';
// import '../../domain/entities/example_entity.dart';

// part 'example_model.g.dart';

// @JsonSerializable()
// class ExampleModel extends ExampleEntity {
//   const ExampleModel({
//     required super.id,
//     required super.title,
//     required super.description,
//     required super.createdAt,
//   });

//   factory ExampleModel.fromJson(Map<String, dynamic> json) =>
//       _\$ExampleModelFromJson(json);

//   Map<String, dynamic> toJson() => _\$ExampleModelToJson(this);

//   factory ExampleModel.fromEntity(ExampleEntity entity) {
//     return ExampleModel(
//       id: entity.id,
//       title: entity.title,
//       description: entity.description,
//       createdAt: entity.createdAt,
//     );
//   }

//   ExampleEntity toEntity() {
//     return ExampleEntity(
//       id: id,
//       title: title,
//       description: description,
//       createdAt: createdAt,
//     );
//   }
// }
// ''';
//   }

//   static String generateExampleRepository() {
//     return '''import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../entities/example_entity.dart';

// abstract class ExampleRepository {
//   Future<Either<Failure, List<ExampleEntity>>> getExamples();
//   Future<Either<Failure, ExampleEntity>> getExample(int id);
//   Future<Either<Failure, ExampleEntity>> createExample(ExampleEntity example);
//   Future<Either<Failure, ExampleEntity>> updateExample(ExampleEntity example);
//   Future<Either<Failure, void>> deleteExample(int id);
// }
// ''';
//   }

//   static String generateExampleRepositoryImpl() {
//     return '''import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/error/exceptions.dart';
// import '../../../core/network/network_info.dart';
// import '../../domain/entities/example_entity.dart';
// import '../../domain/repositories/example_repository.dart';
// import '../datasources/example_remote_datasource.dart';
// import '../datasources/example_local_datasource.dart';
// import '../models/example_model.dart';

// class ExampleRepositoryImpl implements ExampleRepository {
//   final ExampleRemoteDataSource remoteDataSource;
//   final ExampleLocalDataSource localDataSource;
//   final NetworkInfo networkInfo;

//   ExampleRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, List<ExampleEntity>>> getExamples() async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteExamples = await remoteDataSource.getExamples();
//         await localDataSource.cacheExamples(remoteExamples);
//         return Right(remoteExamples.map((model) => model.toEntity()).toList());
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         final localExamples = await localDataSource.getCachedExamples();
//         return Right(localExamples.map((model) => model.toEntity()).toList());
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, ExampleEntity>> getExample(int id) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteExample = await remoteDataSource.getExample(id);
//         await localDataSource.cacheExample(remoteExample);
//         return Right(remoteExample.toEntity());
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         final localExample = await localDataSource.getCachedExample(id);
//         return Right(localExample.toEntity());
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, ExampleEntity>> createExample(ExampleEntity example) async {
//     try {
//       final model = ExampleModel.fromEntity(example);
//       final createdExample = await remoteDataSource.createExample(model);
//       return Right(createdExample.toEntity());
//     } on ServerException {
//       return Left(ServerFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, ExampleEntity>> updateExample(ExampleEntity example) async {
//     try {
//       final model = ExampleModel.fromEntity(example);
//       final updatedExample = await remoteDataSource.updateExample(model);
//       return Right(updatedExample.toEntity());
//     } on ServerException {
//       return Left(ServerFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteExample(int id) async {
//     try {
//       await remoteDataSource.deleteExample(id);
//       await localDataSource.removeExample(id);
//       return const Right(null);
//     } on ServerException {
//       return Left(ServerFailure());
//     }
//   }
// }
// ''';
//   }

//   static String generateExampleUseCase() {
//     return '''import 'package:dartz/dartz.dart';
// import '../../../core/error/failures.dart';
// import '../../../core/usecases/usecase.dart';
// import '../entities/example_entity.dart';
// import '../repositories/example_repository.dart';

// class GetExamples implements UseCase<List<ExampleEntity>, NoParams> {
//   final ExampleRepository repository;

//   GetExamples(this.repository);

//   @override
//   Future<Either<Failure, List<ExampleEntity>>> call(NoParams params) async {
//     return await repository.getExamples();
//   }
// }

// class GetExample implements UseCase<ExampleEntity, GetExampleParams> {
//   final ExampleRepository repository;

//   GetExample(this.repository);

//   @override
//   Future<Either<Failure, ExampleEntity>> call(GetExampleParams params) async {
//     return await repository.getExample(params.id);
//   }
// }

// class GetExampleParams {
//   final int id;

//   GetExampleParams({required this.id});
// }
// ''';
//   }

//   static String generateExampleController() {
//     return '''import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import '../../../core/usecases/usecase.dart';
// import '../../../core/error/failures.dart';
// import '../../domain/entities/example_entity.dart';
// import '../../domain/usecases/get_example.dart';

// part 'example_state.dart';

// class ExampleCubit extends Cubit<ExampleState> {
//   final GetExamples getExamples;
//   final GetExample getExample;

//   ExampleCubit({
//     required this.getExamples,
//     required this.getExample,
//   }) : super(ExampleInitial());

//   Future<void> loadExamples() async {
//     emit(ExampleLoading());
    
//     final result = await getExamples(NoParams());
    
//     result.fold(
//       (failure) => emit(ExampleError(_mapFailureToMessage(failure))),
//       (examples) => emit(ExampleLoaded(examples)),
//     );
//   }

//   Future<void> loadExample(int id) async {
//     emit(ExampleLoading());
    
//     final result = await getExample(GetExampleParams(id: id));
    
//     result.fold(
//       (failure) => emit(ExampleError(_mapFailureToMessage(failure))),
//       (example) => emit(ExampleDetailLoaded(example)),
//     );
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return 'Server Failure';
//       case CacheFailure:
//         return 'Cache Failure';
//       case NetworkFailure:
//         return 'Network Failure';
//       default:
//         return 'Unexpected Error';
//     }
//   }
// }
// ''';
//   }

//   static String generateExampleState() {
//     return '''part of 'example_controller.dart';

// abstract class ExampleState extends Equatable {
//   const ExampleState();

//   @override
//   List<Object> get props => [];
// }

// class ExampleInitial extends ExampleState {}

// class ExampleLoading extends ExampleState {}

// class ExampleLoaded extends ExampleState {
//   final List<ExampleEntity> examples;

//   const ExampleLoaded(this.examples);

//   @override
//   List<Object> get props => [examples];
// }

// class ExampleDetailLoaded extends ExampleState {
//   final ExampleEntity example;

//   const ExampleDetailLoaded(this.example);

//   @override
//   List<Object> get props => [example];
// }

// class ExampleError extends ExampleState {
//   final String message;

//   const ExampleError(this.message);

//   @override
//   List<Object> get props => [message];
// }
// ''';
//   }

//   static String generateExampleScreen() {
//     return '''import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/core.dart';
// import '../controllers/example_controller.dart';

// class ExampleScreen extends StatelessWidget {
//   const ExampleScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ExampleCubit(
//         getExamples: getIt(),
//         getExample: getIt(),
//       )..loadExamples(),
//       child: const ExampleView(),
//     );
//   }
// }

// class ExampleView extends StatelessWidget {
//   const ExampleView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Examples'),
//       ),
//       body: BlocBuilder<ExampleCubit, ExampleState>(
//         builder: (context, state) {
//           if (state is ExampleLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ExampleLoaded) {
//             return ListView.builder(
//               itemCount: state.examples.length,
//               itemBuilder: (context, index) {
//                 final example = state.examples[index];
//                 return ListTile(
//                   title: Text(example.title),
//                   subtitle: Text(example.description),
//                   onTap: () {
//                     context.read<ExampleCubit>().loadExample(example.id);
//                   },
//                 );
//               },
//             );
//           } else if (state is ExampleError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(state.message),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<ExampleCubit>().loadExamples();
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return const Center(child: Text('Welcome to Example Feature'));
//         },
//       ),
//     );
//   }
// }
// ''';
//   }
// }
// ''';
//   }
// }
