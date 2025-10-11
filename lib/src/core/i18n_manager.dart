/// Main i18n manager singleton
library;

import 'i18n_config.dart';
import 'i18n_loader.dart';
import 'i18n_utils.dart';

/// Singleton class for managing internationalization
class MayrI18n {
  static final MayrI18n instance = MayrI18n._internal();

  MayrI18n._internal();

  Map<String, Map<String, String>> _allTranslations = {};
  Map<String, String> _currentTranslations = {};
  String _currentLocale = 'en';
  I18nConfig? _config;
  bool _isInitialized = false;

  /// Get the current locale
  String get currentLocale => _currentLocale;

  /// Get the configuration
  I18nConfig? get config => _config;

  /// Check if the manager is initialized
  bool get isInitialized => _isInitialized;

  /// Load translations from the configured directory
  Future<void> load({String? path, String? locale}) async {
    // Load configuration
    _config = await I18nConfig.load();

    // Use provided path or config path
    final directory = path ?? _config!.langDirectory;

    // Load all translations
    _allTranslations = await I18nLoader.loadAllTranslations(directory);

    // Set current locale
    final initialLocale = locale ?? _config!.defaultLocale;
    if (!_allTranslations.containsKey(initialLocale)) {
      throw Exception('Locale not found: $initialLocale');
    }

    _currentLocale = initialLocale;
    _currentTranslations = _allTranslations[_currentLocale]!;
    _isInitialized = true;
  }

  /// Translate a key with optional arguments
  String tr(String key, {Map<String, String>? args}) {
    if (!_isInitialized) {
      throw Exception('MayrI18n not initialized. Call load() first.');
    }

    final translation = _currentTranslations[key];

    if (translation == null) {
      return key; // Return key if translation not found
    }

    return replacePlaceholders(translation, args);
  }

  /// Change the current language
  void changeLanguage(String locale) {
    if (!_isInitialized) {
      throw Exception('MayrI18n not initialized. Call load() first.');
    }

    if (!_allTranslations.containsKey(locale)) {
      throw Exception('Locale not found: $locale');
    }

    _currentLocale = locale;
    _currentTranslations = _allTranslations[locale]!;
  }

  /// Check if a key exists in the current locale
  bool keyExists(String key) {
    return _currentTranslations.containsKey(key);
  }

  /// Get all available locales
  List<String> getAvailableLocales() {
    return _allTranslations.keys.toList();
  }

  /// Get all keys for the current locale
  Set<String> getAllKeys() {
    return _currentTranslations.keys.toSet();
  }

  /// Get all translations for the current locale
  Map<String, String> getCurrentTranslations() {
    return Map.from(_currentTranslations);
  }

  /// Get all translations for all locales
  Map<String, Map<String, String>> getAllTranslations() {
    return Map.from(_allTranslations);
  }
}
