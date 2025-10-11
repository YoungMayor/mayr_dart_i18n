# Quick Reference Guide

## Installation

```bash
dart pub add mayr_i18n
```

## Configuration (pubspec.yaml)

```yaml
mayr_i18n:
  lang_directory: assets/i18n
  default_locale: en
  env_support: true
```

## Basic Usage

### Initialize

```dart
import 'package:mayr_i18n/mayr_i18n.dart';

await MayrI18n.instance.load();
```

### Translate

```dart
// Direct method
MayrI18n.instance.tr('app.welcome');

// With placeholders
MayrI18n.instance.tr('app.welcome', args: {'name': 'John'});

// Using extension (recommended)
'app.welcome'.tr();
'app.welcome'.tr(args: {'name': 'John'});
```

### Switch Language

```dart
MayrI18n.instance.changeLanguage('fr');
```

### Check Key Exists

```dart
if (MayrI18n.instance.keyExists('app.welcome')) {
  // Use translation
}
```

### Get Available Locales

```dart
List<String> locales = MayrI18n.instance.getAvailableLocales();
```

## CLI Commands

### Verify Keys

```bash
dart run mayr_i18n verify
```

Checks all translation files for missing keys.

### Sync Keys

```bash
dart run mayr_i18n sync
```

Adds missing keys across all files with empty placeholders.

### Audit Usage

```bash
dart run mayr_i18n audit
```

Scans your code for `.tr()` usage and reports:
- Keys used but not defined
- Keys defined but not used

### Create New Locale

```bash
dart run mayr_i18n create es
```

Creates a new translation file with the same structure as existing files.

## JSON Structure

```json
{
  "app": {
    "welcome": "Welcome, {name}!",
    "logout": "Goodbye"
  },
  "auth": {
    "errors": {
      "invalid": "Invalid credentials"
    }
  }
}
```

Access with dot notation:
- `app.welcome`
- `app.logout`
- `auth.errors.invalid`

## Best Practices

1. **Organize keys logically** - Use dot notation to group related translations
2. **Use the extension** - `.tr()` is cleaner than `MayrI18n.instance.tr()`
3. **Run verify regularly** - Catch missing translations early
4. **Use audit before release** - Ensure no unused translations
5. **Keep translations flat** - Avoid deep nesting (3 levels max recommended)
6. **Document placeholders** - Make it clear what `{name}` or `{count}` represent

## Common Patterns

### Optional Translations

```dart
final text = MayrI18n.instance.keyExists('optional.key')
    ? 'optional.key'.tr()
    : 'Default text';
```

### Dynamic Locale Selection

```dart
void setUserLanguage(String locale) {
  if (MayrI18n.instance.getAvailableLocales().contains(locale)) {
    MayrI18n.instance.changeLanguage(locale);
  }
}
```

### Placeholder Formatting

```dart
// In JSON: "greeting": "Hello {name}, you have {count} messages"
'greeting'.tr(args: {
  'name': userName,
  'count': messageCount.toString(),
});
```

## Troubleshooting

### "MayrI18n not initialized" Error

Make sure you call `await MayrI18n.instance.load()` before using translations.

### Missing Keys

Run `dart run mayr_i18n verify` to find missing keys, then `dart run mayr_i18n sync` to fix them.

### Translation Not Found

The package returns the key itself if translation is not found. Check:
1. Key spelling matches exactly
2. Key exists in current locale
3. JSON is valid (run `dart run mayr_i18n verify`)

## API Reference

### MayrI18n

| Method | Description |
|--------|-------------|
| `load({path, locale})` | Initialize and load translations |
| `tr(key, {args})` | Translate a key with optional args |
| `changeLanguage(locale)` | Switch to a different locale |
| `keyExists(key)` | Check if key exists in current locale |
| `getAvailableLocales()` | Get list of all loaded locales |
| `getAllKeys()` | Get all keys in current locale |
| `getCurrentTranslations()` | Get all translations for current locale |

### String Extension

| Method | Description |
|--------|-------------|
| `.tr({args})` | Translate this string |
