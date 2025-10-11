![License](https://img.shields.io/badge/license-MIT-blue.svg?label=Licence)
![Platform](https://img.shields.io/badge/Platform-Flutter-blue.svg)

![Pub Version](https://img.shields.io/pub/v/mayr_i18n?style=plastic&label=Version)
![Pub.dev Score](https://img.shields.io/pub/points/mayr_i18n?label=Score&style=plastic)
![Pub Likes](https://img.shields.io/pub/likes/mayr_i18n?label=Likes&style=plastic)
![Pub.dev Publisher](https://img.shields.io/pub/publisher/mayr_i18n?label=Publisher&style=plastic)
![Downloads](https://img.shields.io/pub/dm/mayr_i18n.svg?label=Downloads&style=plastic)

![Build Status](https://img.shields.io/github/actions/workflow/status/YoungMayor/mayr_dart_i18n/ci.yaml?label=Build)
![Issues](https://img.shields.io/github/issues/YoungMayor/mayr_dart_i18n.svg?label=Issues)
![Last Commit](https://img.shields.io/github/last-commit/YoungMayor/mayr_dart_i18n.svg?label=Latest%20Commit)
![Contributors](https://img.shields.io/github/contributors/YoungMayor/mayr_dart_i18n.svg?label=Contributors)


# 🌍 mayr_i18n

> **Simple, JSON-controlled internationalization for Dart projects**
> ✨ Easy to set up • 🧩 CLI powered • 🔍 Key-safe • ⚡ Extensible

---

## 🧠 Overview

`mayr_i18n` makes localization dead simple.
It lets you manage your translations in **plain JSON files**, verify and sync them via **CLI commands**, and translate strings dynamically with `'.tr()'`.

It’s the perfect foundation for both **Dart** and **Flutter** apps, with a Flutter wrapper (`mayr_i18n_flutter`) coming soon.

---

## 🚀 Features

✅ Supports **nested JSON**
✅ Works with **non-standard languages** like `genz.json` or `pidgin.json`
✅ Built-in **key verification**, **sync**, **audit**, and **file creation** tools
✅ `.tr()` translation lookup with variable interpolation
✅ Configurable via `pubspec.yaml` or `.env`
✅ Lightweight, no Flutter dependency
✅ Extensible architecture — code-gen and pluralization ready

---

## 📦 Installation

```bash
dart pub add mayr_i18n
```

---

## ⚙️ Configuration

In your project’s **pubspec.yaml**, add:

```yaml
mayr_i18n:
  lang_directory: assets/i18n
  default_locale: en
  env_support: true
```

Optional `.env` overrides:

```bash
MAYR_I18N_DEFAULT_LOCALE=en
MAYR_I18N_LANG_DIRECTORY=assets/i18n
```

Then place your translation files here:

```
assets/i18n/
├── en.json
├── fr.json
└── genz.json
```

---

## 🧩 Example JSON

`assets/i18n/en.json`

```json
{
  "app": {
    "welcome": "Welcome, {name}!",
    "logout": "You’ve been logged out."
  }
}
```

`assets/i18n/genz.json`

```json
{
  "app": {
    "welcome": "Yo {name}, what’s good?",
    "logout": "Catch you later!"
  }
}
```

---

## 🧠 Usage

```dart
import 'package:mayr_i18n/mayr_i18n.dart';

Future<void> main() async {
  await MayrI18n.instance.load(); // Loads from config

  print('app.welcome'.tr(args: {'name': 'Mayor'}));
  // Output → Welcome, Mayor!

  MayrI18n.instance.changeLanguage('genz');
  print('app.welcome'.tr(args: {'name': 'Mayor'}));
  // Output → Yo Mayor, what’s good?
}
```

### 🔡 String extension

```dart
'app.logout'.tr(); // simple key lookup
'user.greeting'.tr(args: {'name': 'Tovia'});
```

---

## 🛠 CLI Commands

Run all commands using:

```bash
dart run mayr_i18n <command>
```

### ✅ `verify`

Checks that all JSON files contain the same keys.

```bash
dart run mayr_i18n verify
```

Output:

```
⚠️ Missing key in fr.json: app.logout
✅ All keys verified in en.json, genz.json
```

---

### 🔄 `sync`

Adds any missing keys across language files (with empty placeholders).

```bash
dart run mayr_i18n sync
```

Output:

```
🧩 Synced 3 missing keys in fr.json
```

---

### 🧹 `audit`

Scans your codebase for translation key usage.

It shows:

* Keys **used but not defined**
* Keys **defined but unused**

```bash
dart run mayr_i18n audit
```

Output:

```
❌ Missing keys: profile.title
🧩 Unused keys: app.oldFeature
```

---

### ➕ `create <lang>`

Create a new translation file quickly.

```bash
dart run mayr_i18n create pidgin
```

Output:

```
✅ Created assets/i18n/pidgin.json
```

---

## 🧩 Nested Keys

Supports deeply nested JSON structures:

```json
{
  "auth": {
    "errors": {
      "invalid": "Invalid credentials"
    }
  }
}
```

Usage:

```dart
'auth.errors.invalid'.tr();
```

---

## 🧠 Language Switching

```dart
MayrI18n.instance.changeLanguage('genz');
```

---

## 🧰 CLI Tools

| Command         | Description                        |
| --------------- | ---------------------------------- |
| `verify`        | Check missing keys                 |
| `sync`          | Add missing keys to files          |
| `audit`         | Detect unused/missing keys in code |
| `create <lang>` | Create a new language JSON         |

---

## 🧠 Example Project Structure

```
lib/
  main.dart
assets/
  i18n/
    en.json
    fr.json
pubspec.yaml
.env
```

---

## 🧩 Coming Soon: `mayr_i18n_flutter`

The Flutter version will add:

* `MayrI18nWidget` for wrapping `MaterialApp`
* Automatic reactive rebuild on language change
* Persistent language setting with `SharedPreferences`
* Built-in `LanguageSwitcher` widget

---

## 🧱 Internal Architecture (Quick Summary)

| Component           | Role                                               |
| ------------------- | -------------------------------------------------- |
| **MayrI18n**        | Singleton managing current locale and translations |
| **StringExtension** | Adds `.tr()` method                                |
| **CLI Commands**    | Verify, sync, audit, create                        |
| **Config Reader**   | Parses `pubspec.yaml` and `.env`                   |
| **JSON Loader**     | Loads and flattens translation trees               |

---

## 🔧 Example Output

```
🌍  mayr_i18n v1.0.0

Running verify...
✅ All good — 3 files, 124 keys verified.

Tip: Run `mayr_i18n sync` to auto-fix missing keys.
```

---

## 💡 Pro Tip

Run all i18n tasks automatically before release:

```bash
dart run mayr_i18n verify && dart run mayr_i18n audit
```

---

## 📢 Additional Information

### 🤝 Contributing
Contributions are highly welcome!
If you have ideas for new extensions, improvements, or fixes, feel free to fork the repository and submit a pull request.

Please make sure to:
- Follow the existing coding style.
- Write tests for new features.
- Update documentation if necessary.

> Let's build something amazing together!

---

### 🐛 Reporting Issues
If you encounter a bug, unexpected behaviour, or have feature requests:
- Open an issue on the repository.
- Provide a clear description and steps to reproduce (if it's a bug).
- Suggest improvements if you have any ideas.

> Your feedback helps make the package better for everyone!

---

### 🧑‍💻 Author

**MayR Labs**

Crafting clean, reliable, and human-centric Flutter and Dart solutions.
🌍 [mayrlabs.com](https://mayrlabs.com)

---

### 📜 Licence
This package is licensed under the MIT License — which means you are free to use it for commercial and non-commercial projects, with proper attribution.

> See the [LICENSE](LICENSE) file for more details.

MIT © 2025 [MayR Labs](https://github.com/mayrlabs)

---

## 🌟 Support

If you find this package helpful, please consider giving it a ⭐️ on GitHub — it motivates and helps the project grow!

You can also support by:
- Sharing the package with your friends, colleagues, and tech communities.
- Using it in your projects and giving feedback.
- Contributing new ideas, features, or improvements.

> Every little bit of support counts! 🚀💙
