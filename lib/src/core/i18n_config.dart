/// Configuration reader for mayr_i18n
library;

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

/// Configuration class for mayr_i18n
class I18nConfig {
  final String langDirectory;
  final String defaultLocale;

  I18nConfig({required this.langDirectory, required this.defaultLocale});

  /// Load configuration from pubspec.yaml
  static Future<I18nConfig> load() async {
    // Default values
    String langDirectory = 'assets/i18n';
    String defaultLocale = 'en';

    // Try to load from pubspec.yaml
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();
      final yaml = loadYaml(content) as Map;

      if (yaml.containsKey('mayr_i18n')) {
        final config = yaml['mayr_i18n'] as Map;
        langDirectory = config['lang_directory'] ?? langDirectory;
        defaultLocale = config['default_locale'] ?? defaultLocale;
      }
    }

    // Check for .env overrides
    final envFile = File('.env');
    if (await envFile.exists()) {
      final envContent = await envFile.readAsLines();
      for (final line in envContent) {
        if (line.startsWith('MAYR_I18N_DEFAULT_LOCALE=')) {
          defaultLocale = line.split('=')[1].trim();
        } else if (line.startsWith('MAYR_I18N_LANG_DIRECTORY=')) {
          langDirectory = line.split('=')[1].trim();
        }
      }
    }

    return I18nConfig(
      langDirectory: langDirectory,
      defaultLocale: defaultLocale,
    );
  }

  /// Get the full path to the language directory
  String getLanguageDirectoryPath() {
    return langDirectory;
  }

  /// Get the path for a specific locale file
  String getLocaleFilePath(String locale) {
    return p.join(langDirectory, '$locale.json');
  }
}
