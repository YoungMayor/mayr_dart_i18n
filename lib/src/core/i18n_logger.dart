/// Logger utility for CLI output with colors and emojis
library;

/// Provides colorized console output for CLI commands
class I18nLogger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';
  static const String _bold = '\x1B[1m';

  /// Log an error message with ❌ emoji
  static void error(String message) {
    print('$_red❌ $message$_reset');
  }

  /// Log a success message with ✅ emoji
  static void success(String message) {
    print('$_green✅ $message$_reset');
  }

  /// Log a warning message with ⚠️ emoji
  static void warning(String message) {
    print('$_yellow⚠️  $message$_reset');
  }

  /// Log an info message with 🧩 emoji
  static void info(String message) {
    print('$_cyan🧩 $message$_reset');
  }

  /// Log a header message with bold text
  static void header(String message) {
    print('$_bold$_blue$message$_reset');
  }

  /// Log a plain message without formatting
  static void plain(String message) {
    print(message);
  }

  /// Log a tip message
  static void tip(String message) {
    print('$_cyan💡 Tip: $message$_reset');
  }
}
