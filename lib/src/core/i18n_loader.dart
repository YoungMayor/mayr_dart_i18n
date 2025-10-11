/// Loader for i18n JSON files
library;

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'i18n_utils.dart';

/// Handles loading and parsing of JSON translation files
class I18nLoader {
  /// Load all JSON files from the specified directory
  static Future<Map<String, Map<String, String>>> loadAllTranslations(
    String directory,
  ) async {
    final result = <String, Map<String, String>>{};

    final dir = Directory(directory);
    if (!await dir.exists()) {
      throw Exception('Translation directory not found: $directory');
    }

    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        final locale = p.basenameWithoutExtension(entity.path);
        final translations = await loadTranslationFile(entity.path);
        result[locale] = translations;
      }
    }

    if (result.isEmpty) {
      throw Exception('No translation files found in: $directory');
    }

    return result;
  }

  /// Load a single translation file
  static Future<Map<String, String>> loadTranslationFile(
    String filePath,
  ) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('Translation file not found: $filePath');
    }

    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return flattenJson(json);
    } catch (e) {
      throw Exception('Error parsing JSON in $filePath: $e');
    }
  }

  /// Save translations to a file
  static Future<void> saveTranslationFile(
    String filePath,
    Map<String, String> translations,
  ) async {
    final file = File(filePath);

    // Unflatten the translations back to nested structure
    final nested = unflattenJson(translations);

    // Create directory if it doesn't exist
    await file.parent.create(recursive: true);

    // Write with pretty formatting
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(nested));
  }

  /// Unflatten a map with dot notation keys back to nested structure
  static Map<String, dynamic> unflattenJson(Map<String, String> flat) {
    final result = <String, dynamic>{};

    flat.forEach((key, value) {
      final parts = key.split('.');
      Map<String, dynamic> current = result;

      for (int i = 0; i < parts.length - 1; i++) {
        final part = parts[i];
        current[part] ??= <String, dynamic>{};
        current = current[part] as Map<String, dynamic>;
      }

      current[parts.last] = value;
    });

    return result;
  }

  /// List all available locales in a directory
  static Future<List<String>> listLocales(String directory) async {
    final dir = Directory(directory);
    if (!await dir.exists()) {
      return [];
    }

    final locales = <String>[];
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        locales.add(p.basenameWithoutExtension(entity.path));
      }
    }

    return locales;
  }
}
