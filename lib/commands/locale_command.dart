import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

const _preservedKeywords = [
  'few',
  'many',
  'one',
  'other',
  'two',
  'zero',
  'male',
  'female',
];

class LocaleCommand {
  Future<void> execute(ArgResults command) async {
    final options = GenerateOptions()
      ..sourceDir = command['source-dir'] as String?
      ..sourceFile = command['source-file'] as String?
      ..outputDir = command['output-dir'] as String?
      ..outputFile = command['output-file'] as String?
      ..format = command['format'] as String?
      ..skipUnnecessaryKeys = command['skip-unnecessary-keys'] as bool?;

    await _handleLangFiles(options);
  }

  Future<void> _handleLangFiles(GenerateOptions options) async {
    final current = Directory.current;
    final source = Directory.fromUri(Uri.parse(options.sourceDir!));
    final output = Directory.fromUri(Uri.parse(options.outputDir!));
    final sourcePath = Directory(path.join(current.path, source.path));
    final outputPath =
        Directory(path.join(current.path, output.path, options.outputFile));

    if (!await sourcePath.exists()) {
      stderr.writeln('Source path does not exist');
      return;
    }

    var files = await _dirContents(sourcePath);
    if (options.sourceFile != null) {
      final sourceFile = File(path.join(source.path, options.sourceFile));
      if (!await sourceFile.exists()) {
        stderr.writeln('Source file does not exist (${sourceFile.toString()})');
        return;
      }
      files = [sourceFile];
    } else {
      //filtering format
      files = files.where((f) => f.path.contains('.json')).toList();
    }

    if (files.isNotEmpty) {
      await _generateFile(files, outputPath, options);
    } else {
      stderr.writeln('Source path empty');
    }
  }

  Future<List<FileSystemEntity>> _dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen(
      (file) => files.add(file),
      onDone: () => completer.complete(files),
    );
    return completer.future;
  }

  Future<void> _generateFile(
    List<FileSystemEntity> files,
    Directory outputPath,
    GenerateOptions options,
  ) async {
    var generatedFile = File(outputPath.path);
    if (!generatedFile.existsSync()) {
      generatedFile.createSync(recursive: true);
    }

    var classBuilder = StringBuffer();

    switch (options.format) {
      case 'json':
        await _writeJson(classBuilder, files);
        break;
      case 'keys':
        await _writeKeys(classBuilder, files, options.skipUnnecessaryKeys);
        break;

      default:
        stderr.writeln('Format not supported');
    }

    classBuilder.writeln('}');
    generatedFile.writeAsStringSync(classBuilder.toString());

    stdout.writeln('All done! File generated in ${outputPath.path}');
  }

  Future _writeKeys(
    StringBuffer classBuilder,
    List<FileSystemEntity> files,
    bool? skipUnnecessaryKeys,
  ) async {
    var file = '''
// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

abstract class  LocaleKeys {
''';

    final fileData = File(files.first.path);

    Map<String, dynamic> translations =
        json.decode(await fileData.readAsString());

    file += _resolve(translations, skipUnnecessaryKeys);

    classBuilder.writeln(file);
  }

  String _resolve(
    Map<String, dynamic> translations,
    bool? skipUnnecessaryKeys, [
    String? accKey,
  ]) {
    var fileContent = '';

    final sortedKeys = translations.keys.toList();
    final canIgnoreKeys = skipUnnecessaryKeys == true;

    bool containsPreservedKeywords(Map<String, dynamic> map) =>
        map.keys.any((element) => _preservedKeywords.contains(element));

    for (var key in sortedKeys) {
      var ignoreKey = false;
      if (translations[key] is Map) {
        // If key does not contain keys for plural(), gender() etc. and option is enabled -> ignore it
        ignoreKey = !containsPreservedKeywords(
              translations[key] as Map<String, dynamic>,
            ) &&
            canIgnoreKeys;

        var nextAccKey = key;
        if (accKey != null) {
          nextAccKey = '$accKey.$key';
        }

        fileContent +=
            _resolve(translations[key], skipUnnecessaryKeys, nextAccKey);
      } else if (!_preservedKeywords.contains(key)) {
        // final keyName =
        //     key.replaceAll('-', '_').replaceAll('/', '_').replaceAll(', ', '_');
        // print(key);

        //  final keyName = key.replaceAll('-', '_').replaceAll('/', '_').replaceAll(', ', '_');
        if (accKey != null && !ignoreKey) {
          final keyName = '${accKey}_$key'.removeAndFirstUpperCase();

          fileContent += '  static const $keyName = \'$accKey.$key\';\n';
        } else if (!ignoreKey) {
          final keyName = key
              .replaceAll('-', '_')
              .replaceAll('/', '_')
              .replaceAll(', ', '_');
          fileContent += '  static const $keyName = \'$key\';\n';
        }
      }
    }

    return fileContent;
  }

  Future _writeJson(
    StringBuffer classBuilder,
    List<FileSystemEntity> files,
  ) async {
    var gFile = '''
// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  ''';

    final listLocales = [];

    for (var file in files) {
      final localeName = path
          .basename(file.path)
          .replaceFirst('.json', '')
          .replaceAll('-', '_');
      listLocales.add('"$localeName": $localeName');
      final fileData = File(file.path);

      Map<String, dynamic>? data = json.decode(await fileData.readAsString());

      final mapString = const JsonEncoder.withIndent('  ').convert(data);
      gFile += 'static const Map<String,dynamic> $localeName = $mapString;\n';
    }

    gFile +=
        'static const Map<String, Map<String,dynamic>> mapLocales = {${listLocales.join(', ')}};';
    classBuilder.writeln(gFile);
  }
}

class GenerateOptions {
  String? sourceDir;
  String? sourceFile;
  String? templateLocale;
  String? outputDir;
  String? outputFile;
  String? format;
  bool? skipUnnecessaryKeys;

  @override
  String toString() {
    return 'format: $format sourceDir: $sourceDir sourceFile: $sourceFile outputDir: $outputDir outputFile: $outputFile skipUnnecessaryKeys: $skipUnnecessaryKeys';
  }
}

extension StringExtensions on String {
  String firstLetterUpperCase() => length > 1
      ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
      : this;

  String firstLetterLowerCase() =>
      length > 1 ? '${this[0].toLowerCase()}${substring(1)}' : this;

  String removeAndFirstUpperCase() {
    // Remove underscores
    String result = replaceAll('_', ' ');

    // Capitalize the first letter of each word
    List<String> words = result.split(' ');
    List<String> capitalizedWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1)).toList();
    return capitalizedWords.join('').firstLetterLowerCase();
  }
}
