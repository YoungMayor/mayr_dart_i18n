# 🧩 **Design Document: `mayr_i18n`**

### **Overview**

`mayr_i18n` is a Dart-based, JSON-powered internationalization (i18n) package that provides:

* Simplified translation management
* CLI utilities for syncing and verifying language files
* Full integration with `.env` and `pubspec.yaml` for configuration
* Optional Flutter wrapper (`mayr_i18n_flutter`) for UI integration

---

## 🧱 **Core Architecture**

### **1. Package Layers**

| Layer             | Description                                                                              |
| ----------------- | ---------------------------------------------------------------------------------------- |
| **Core (`lib/`)** | Handles language file loading, translation lookup, and runtime management.               |
| **CLI (`bin/`)**  | Provides command-line utilities for verification, syncing, auditing, and file creation.  |
| **Config Parser** | Reads settings from `pubspec.yaml` and optionally `.env` for environment-based defaults. |
| **Utils**         | JSON tree traversal, key diffing, file I/O, logging helpers.                             |

---

## ⚙️ **Configuration**

Defined under `pubspec.yaml`:

```yaml
mayr_i18n:
  lang_directory: assets/i18n
  default_locale: en
  env_support: true
```

Optional `.env`:

```
MAYR_I18N_DEFAULT_LOCALE=en
MAYR_I18N_LANG_DIRECTORY=assets/i18n
```

`MayrI18n` loads these automatically using `package:pubspec_parse` and `package:dotenv`.

---

## 📁 **Directory Structure**

```
mayr_i18n/
├── lib/
│   ├── mayr_i18n.dart
│   ├── src/
│   │   ├── core/
│   │   │   ├── i18n_manager.dart
│   │   │   ├── i18n_loader.dart
│   │   │   ├── i18n_utils.dart
│   │   │   ├── i18n_config.dart
│   │   │   └── i18n_logger.dart
│   │   └── models/
│   │       └── i18n_entry.dart
│   └── extensions/
│       └── string_extension.dart
├── bin/
│   └── mayr_i18n.dart
├── example/
│   └── main.dart
└── assets/
    └── i18n/
        ├── en.json
        ├── fr.json
        └── genz.json
```

---

## 🧠 **Core Components**

### **1. `MayrI18n` Singleton**

Responsible for:

* Loading JSONs
* Switching locales
* Translating keys
* Providing `.tr()` extension

```dart
class MayrI18n {
  static final MayrI18n instance = MayrI18n._internal();
  late Map<String, dynamic> _translations;
  String _currentLocale = 'en';

  Future<void> load({String? path, String? locale}) async { ... }

  String tr(String key, {Map<String, String>? args}) { ... }

  void changeLanguage(String locale) { ... }

  bool keyExists(String key) { ... }
}
```

---

### **2. String Extension**

```dart
extension I18nStringExtension on String {
  String tr({Map<String, String>? args}) =>
      MayrI18n.instance.tr(this, args: args);
}
```

Usage:

```dart
print('app.welcome'.tr(args: {'name': 'Mayor'}));
```

---

### **3. File Loader (`i18n_loader.dart`)**

* Loads all JSON files from configured directory.
* Validates that each is a valid JSON structure.
* Supports nested key flattening:

  ```json
  { "app": { "welcome": "Hi" } }
  ```

  → becomes `"app.welcome": "Hi"`

---

### **4. Config Reader (`i18n_config.dart`)**

* Reads from `pubspec.yaml`
* If `env_support` is true, loads `.env` overrides
* Returns structured config for CLI and runtime

---

### **5. CLI Commands**

Each command is available via:

```bash
dart run mayr_i18n <command>
```

#### ✅ `verify`

Check for missing keys between JSON files.

```bash
dart run mayr_i18n verify
```

Output:

```
⚠️ Missing key in fr.json: app.logout
✅ All keys verified in en.json, genz.json
```

#### 🔄 `sync`

Add missing keys (empty value placeholders) across all files.

```bash
dart run mayr_i18n sync
```

#### 🧹 `audit`

Scan your project for translation usage.

* Finds `.tr()` calls
* Reports unused/missing keys

```bash
dart run mayr_i18n audit
```

Output:

```
🧩 Unused keys: app.oldFeature
❌ Missing keys: profile.title
```

#### ➕ `create <lang>`

Create a new language file.

```bash
dart run mayr_i18n create pidgin
```

Output:

```
✅ Created assets/i18n/pidgin.json
```

---

## 🧩 **Extensibility**

Future features:

* **Code generation** for type-safe keys (`I18nKeys.app.welcome`)
* **Pluralization support**
* **Async remote translation loading**
* **Flutter integration layer**

  * Reactive UI updates on language change
  * `LocaleSwitcher` widget
  * Persistence via `SharedPreferences`

---

## 🧰 **Dependencies**

| Package                      | Purpose                       |
| ---------------------------- | ----------------------------- |
| `yaml`                       | Parse pubspec.yaml            |
| `dotenv`                     | Load .env configuration       |
| `path`                       | Handle cross-platform paths   |
| `dart:io`                    | File operations               |
| `cli_util`                   | CLI logging, colorized output |
| `json_annotation` (optional) | For code-gen support later    |

---

## 🧑‍💻 **Example Usage**

```dart
import 'package:mayr_i18n/mayr_i18n.dart';

Future<void> main() async {
  await MayrI18n.instance.load();

  print('app.welcome'.tr(args: {'name': 'Mayor'}));
  MayrI18n.instance.changeLanguage('genz');
  print('app.welcome'.tr(args: {'name': 'Mayor'}));
}
```

---

## 🌍 **Example JSON (genz.json)**

```json
{
  "app": {
    "welcome": "Yo {name}, what’s good?",
    "logout": "Catch you later!"
  }
}
```

---

## 🚀 **CLI UX Goal**

Each command should feel clean, with emoji and colors:

```
🌍  mayr_i18n v1.0.0

Running verify...
✅ All good — 3 files, 124 keys verified.

Tip: Run `mayr_i18n sync` to auto-fix missing keys.
```

---

## 🧩 **Next Package: `mayr_i18n_flutter`**

Adds:

* `MayrI18nWidget` for wrapping `MaterialApp`
* `MayrI18n.of(context)` helper
* `MayrLanguageSwitcher` widget
* `SharedPreferences` persistence

---

This structure keeps `mayr_i18n` lightweight and CLI-driven, while the Flutter package focuses on UI reactivity.
