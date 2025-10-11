#!/usr/bin/env dart

/// CLI tool for mayr_i18n
library;

import 'dart:io';
import 'package:mayr_i18n/src/core/i18n_config.dart';
import 'package:mayr_i18n/src/core/i18n_loader.dart';
import 'package:mayr_i18n/src/core/i18n_utils.dart';
import 'package:mayr_i18n/src/core/i18n_logger.dart';

const String version = '1.0.0';

void main(List<String> arguments) async {
  try {
    if (arguments.isEmpty) {
      _printHelp();
      exit(0);
    }

    final command = arguments[0];
    final args = arguments.sublist(1);

    switch (command) {
      case 'verify':
        await _verifyCommand(args);
        break;
      case 'sync':
        await _syncCommand(args);
        break;
      case 'audit':
        await _auditCommand(args);
        break;
      case 'create':
        await _createCommand(args);
        break;
      case 'help':
      case '--help':
      case '-h':
        _printHelp();
        break;
      case 'version':
      case '--version':
      case '-v':
        I18nLogger.header('🌍  mayr_i18n v$version');
        break;
      default:
        I18nLogger.error('Unknown command: $command');
        _printHelp();
        exit(1);
    }
  } catch (e) {
    I18nLogger.error('Error: $e');
    exit(1);
  }
}

void _printHelp() {
  I18nLogger.header('🌍  mayr_i18n v$version');
  I18nLogger.plain('');
  I18nLogger.plain('Usage: dart run mayr_i18n <command> [arguments]');
  I18nLogger.plain('');
  I18nLogger.plain('Commands:');
  I18nLogger.plain('  verify       Check for missing keys between JSON files');
  I18nLogger.plain('  sync         Add missing keys across all files');
  I18nLogger.plain('  audit        Scan project for translation usage');
  I18nLogger.plain('  create       Create a new language file');
  I18nLogger.plain('  help         Show this help message');
  I18nLogger.plain('  version      Show version information');
  I18nLogger.plain('');
}

/// Verify command - checks for missing keys
Future<void> _verifyCommand(List<String> args) async {
  I18nLogger.header('🌍  mayr_i18n v$version');
  I18nLogger.plain('');
  I18nLogger.plain('Running verify...');

  final config = await I18nConfig.load();
  final translations = await I18nLoader.loadAllTranslations(
    config.langDirectory,
  );

  if (translations.isEmpty) {
    I18nLogger.error('No translation files found');
    exit(1);
  }

  // Get all keys from all locales
  final allKeys = <String>{};
  translations.forEach((locale, keys) {
    allKeys.addAll(keys.keys);
  });

  bool hasIssues = false;
  int totalKeys = allKeys.length;

  // Check each locale for missing keys
  translations.forEach((locale, keys) {
    final diff = compareKeys(allKeys, keys.keys.toSet());

    if (!diff.hasNoDifferences) {
      hasIssues = true;
      for (final key in diff.missingKeys) {
        I18nLogger.warning('Missing key in $locale.json: $key');
      }
    }
  });

  if (hasIssues) {
    I18nLogger.plain('');
    I18nLogger.error('Found missing keys in translation files');
    I18nLogger.tip('Run `dart run mayr_i18n sync` to auto-fix missing keys.');
    exit(1);
  } else {
    I18nLogger.plain('');
    I18nLogger.success(
      'All good — ${translations.length} files, $totalKeys keys verified.',
    );
    I18nLogger.plain('');
    I18nLogger.tip('Run `dart run mayr_i18n sync` to auto-fix missing keys.');
  }
}

/// Sync command - adds missing keys
Future<void> _syncCommand(List<String> args) async {
  I18nLogger.header('🌍  mayr_i18n v$version');
  I18nLogger.plain('');
  I18nLogger.plain('Running sync...');

  final config = await I18nConfig.load();
  final translations = await I18nLoader.loadAllTranslations(
    config.langDirectory,
  );

  if (translations.isEmpty) {
    I18nLogger.error('No translation files found');
    exit(1);
  }

  // Get all keys from all locales
  final allKeys = <String>{};
  translations.forEach((locale, keys) {
    allKeys.addAll(keys.keys);
  });

  bool madeChanges = false;

  // Add missing keys to each locale
  for (final locale in translations.keys) {
    final keys = translations[locale]!;
    final diff = compareKeys(allKeys, keys.keys.toSet());

    if (diff.missingKeys.isNotEmpty) {
      madeChanges = true;
      I18nLogger.info(
        'Syncing ${diff.missingKeys.length} keys in $locale.json',
      );

      for (final key in diff.missingKeys) {
        keys[key] = ''; // Add with empty value
      }

      // Save the updated file
      final filePath = config.getLocaleFilePath(locale);
      await I18nLoader.saveTranslationFile(filePath, keys);
    }
  }

  if (madeChanges) {
    I18nLogger.plain('');
    I18nLogger.success(
      'Sync complete! Please fill in the empty translation values.',
    );
  } else {
    I18nLogger.plain('');
    I18nLogger.success('All files are already in sync!');
  }
}

/// Audit command - scans for unused/missing keys
Future<void> _auditCommand(List<String> args) async {
  I18nLogger.header('🌍  mayr_i18n v$version');
  I18nLogger.plain('');
  I18nLogger.plain('Running audit...');

  final config = await I18nConfig.load();
  final translations = await I18nLoader.loadAllTranslations(
    config.langDirectory,
  );

  if (translations.isEmpty) {
    I18nLogger.error('No translation files found');
    exit(1);
  }

  // Get all defined keys
  final definedKeys = <String>{};
  translations.forEach((locale, keys) {
    definedKeys.addAll(keys.keys);
  });

  // Scan lib directory for .tr() usage
  final usedKeys = <String>{};
  await _scanDirectory(Directory('lib'), usedKeys);

  final unusedKeys = definedKeys.difference(usedKeys);
  final missingKeys = usedKeys.difference(definedKeys);

  I18nLogger.plain('');

  if (missingKeys.isNotEmpty) {
    I18nLogger.error('Missing keys (used but not defined):');
    for (final key in missingKeys) {
      I18nLogger.plain('  - $key');
    }
    I18nLogger.plain('');
  }

  if (unusedKeys.isNotEmpty) {
    I18nLogger.info('Unused keys (defined but not used):');
    for (final key in unusedKeys) {
      I18nLogger.plain('  - $key');
    }
    I18nLogger.plain('');
  }

  if (missingKeys.isEmpty && unusedKeys.isEmpty) {
    I18nLogger.success('All keys are properly used!');
  }
}

/// Scan directory for .tr() usage
Future<void> _scanDirectory(Directory dir, Set<String> keys) async {
  if (!await dir.exists()) return;

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();

      // Find .tr() calls with simple regex
      final pattern = RegExp(r"'([^']+)'\.tr\(");
      final matches = pattern.allMatches(content);

      for (final match in matches) {
        final key = match.group(1);
        if (key != null) {
          keys.add(key);
        }
      }

      // Also check for double quotes
      final patternDouble = RegExp(r'"([^"]+)"\.tr\(');
      final matchesDouble = patternDouble.allMatches(content);

      for (final match in matchesDouble) {
        final key = match.group(1);
        if (key != null) {
          keys.add(key);
        }
      }

      // Detect direct manager calls: MayrI18n.instance.tr('key')
      final patternManagerSingle = RegExp(
        r"MayrI18n\.instance\.tr\(\s*'([^']+)'\s*(,|\))",
      );
      final matchesManagerSingle = patternManagerSingle.allMatches(content);

      for (final match in matchesManagerSingle) {
        final key = match.group(1);
        if (key != null) {
          keys.add(key);
        }
      }

      // Detect direct manager calls with double quotes
      final patternManagerDouble = RegExp(
        r'MayrI18n\.instance\.tr\(\s*"([^"]+)"\s*(,|\))',
      );
      final matchesManagerDouble = patternManagerDouble.allMatches(content);

      for (final match in matchesManagerDouble) {
        final key = match.group(1);
        if (key != null) {
          keys.add(key);
        }
      }
    }
  }
}

/// Create command - creates a new language file
Future<void> _createCommand(List<String> args) async {
  if (args.isEmpty) {
    I18nLogger.error('Please specify a locale name');
    I18nLogger.plain('Usage: dart run mayr_i18n create <locale>');
    exit(1);
  }

  final locale = args[0];

  I18nLogger.header('🌍  mayr_i18n v$version');
  I18nLogger.plain('');
  I18nLogger.plain('Creating $locale.json...');

  final config = await I18nConfig.load();
  final filePath = config.getLocaleFilePath(locale);

  final file = File(filePath);
  if (await file.exists()) {
    I18nLogger.error('File already exists: $filePath');
    exit(1);
  }

  // Check if there are other locales to copy structure from
  final existingLocales = await I18nLoader.listLocales(config.langDirectory);

  Map<String, String> template = {};

  if (existingLocales.isNotEmpty) {
    // Use first locale as template
    final templatePath = config.getLocaleFilePath(existingLocales.first);
    final templateTranslations = await I18nLoader.loadTranslationFile(
      templatePath,
    );

    // Create empty template with same keys
    for (final key in templateTranslations.keys) {
      template[key] = '';
    }
  }

  await I18nLoader.saveTranslationFile(filePath, template);

  I18nLogger.plain('');
  I18nLogger.success('Created $filePath');
}
