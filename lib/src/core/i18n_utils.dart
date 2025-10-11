/// Utility functions for i18n operations
library;

/// Flattens a nested JSON map into a single-level map with dot notation keys
/// Example: {'app': {'welcome': 'Hi'}} -> {'app.welcome': 'Hi'}
Map<String, String> flattenJson(
  Map<String, dynamic> json, [
  String prefix = '',
]) {
  final result = <String, String>{};

  json.forEach((key, value) {
    final newKey = prefix.isEmpty ? key : '$prefix.$key';

    if (value is Map<String, dynamic>) {
      result.addAll(flattenJson(value, newKey));
    } else if (value is String) {
      result[newKey] = value;
    }
  });

  return result;
}

/// Replaces placeholders in a string with values from args
/// Example: replacePlaceholders('Hello {name}!', {'name': 'World'}) -> 'Hello World!'
String replacePlaceholders(String text, Map<String, String>? args) {
  if (args == null || args.isEmpty) return text;

  var result = text;
  args.forEach((key, value) {
    result = result.replaceAll('{$key}', value);
  });

  return result;
}

/// Compares two sets of keys and returns the differences
class KeyDiff {
  final Set<String> missingKeys;
  final Set<String> extraKeys;

  KeyDiff({required this.missingKeys, required this.extraKeys});

  bool get hasNoDifferences => missingKeys.isEmpty && extraKeys.isEmpty;
}

/// Compares keys from a target map against a reference set of keys
KeyDiff compareKeys(Set<String> referenceKeys, Set<String> targetKeys) {
  final missing = referenceKeys.difference(targetKeys);
  final extra = targetKeys.difference(referenceKeys);

  return KeyDiff(missingKeys: missing, extraKeys: extra);
}
