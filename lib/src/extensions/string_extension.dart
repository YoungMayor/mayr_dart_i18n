/// String extension for translation
library;

import '../core/i18n_manager.dart';

/// Extension on String to add translation method
extension I18nStringExtension on String {
  /// Translate this string using MayrI18n
  ///
  /// Example:
  /// ```dart
  /// 'app.welcome'.tr(args: {'name': 'John'});
  /// ```
  String tr({Map<String, String>? args}) {
    return MayrI18n.instance.tr(this, args: args);
  }
}
