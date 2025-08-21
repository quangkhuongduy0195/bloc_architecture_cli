class PersistedMixinGenerator {
  static String gen() {
    return '''import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../config.dart';
import '../../../utils/preferences.dart';

mixin PersistedStateMixin<T> {
  // cache key for this state
  String get cacheKey;

// whether to use encrypted storage or not
  bool get encrypted => false;

  /// [Hive] lazy box for storing data
  static late LazyBox _box;

  /// [Hive] lazy box for storing encrypted data
  static late LazyBox _encryptedBox;

  /// [Preferences] for storing data
  static late SharedPreferences localStorage;

  static Future<String?> read(String key) async {
    try {
      return await secureStorage.read(key: key);
    } catch (e) {
      return localStorage.getString(key);
    }
  }

  static Future<void> write(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      await localStorage.setString(key, value);
    }
  }

  static Future<void> delete(String key) async {
    try {
      await secureStorage.delete(key: key);
    } catch (e) {
      await localStorage.remove(key);
    }
  }

  static Future<void> initializeBoxes({String? path}) async {
    // initialize shared preferences
    localStorage = await SharedPreferences.getInstance();

    String? boxName = await read(kKeyBoxName);

    if (boxName == null) {
      boxName = '\$keyAppName-\${Uuid().v4()}';
      await write(kKeyBoxName, boxName);
    }

    String? encryptionKey = await read(getBoxKey(boxName));

    if (encryptionKey == null) {
      encryptionKey = base64Url.encode(Hive.generateSecureKey());
      await write(getBoxKey(boxName), encryptionKey);
    }
    _encryptedBox = await Hive.openLazyBox(
      boxName,
      encryptionCipher: HiveAesCipher(base64Url.decode(encryptionKey)),
    );

    _box = await Hive.openLazyBox('\${keyAppName}_cache', path: path);
  }

  LazyBox get box => encrypted ? _encryptedBox : _box;

  Future<T?> load() async {
    final json = await box.get(cacheKey);
    if (json != null) {
      final state = await fromJson((json as Map).castKeyDeep());
      return state;
    }
    return null;
  }

  /// [save] method to save state to local storage
  Future<void> save([Map<String, dynamic>? data]) async {
    await box.put(cacheKey, data ?? toJson());
  }

  /// [delete] method to delete state from local storage
  /// and clear the cache
  Future<void> remove() async {
    await box.delete(cacheKey);
  }

  /// [fromJson] method to convert json to state
  FutureOr<T> fromJson(Map<String, dynamic> json);

  /// [toJson] method to convert state to json
  Map<String, dynamic> toJson() {
    return {};
  }
}

''';
  }
}
