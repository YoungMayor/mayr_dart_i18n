## 1.0.0 - 2025-10-11

### 🎉 Initial Release

#### Core Features
- ✅ **MayrI18n Singleton Manager** - Central translation management system
- ✅ **JSON-based Translations** - Simple, human-readable translation files
- ✅ **Nested Key Support** - Organize translations with dot notation (e.g., `app.auth.login`)
- ✅ **Dynamic Placeholder Replacement** - Use `{name}` placeholders in translations
- ✅ **String Extension** - Convenient `.tr()` method for cleaner code
- ✅ **Multi-locale Support** - Load and switch between multiple languages at runtime
- ✅ **Configuration System** - Configure via `pubspec.yaml` or `.env` files

#### CLI Tools
- ✅ **verify** - Check for missing keys across translation files
- ✅ **sync** - Automatically add missing keys with empty placeholders
- ✅ **audit** - Scan codebase for unused or missing translation keys
- ✅ **create** - Generate new translation files with proper structure

#### Developer Experience
- ✅ **Comprehensive Tests** - 17 tests covering all functionality
- ✅ **Clean API** - Simple, intuitive methods following Dart conventions
- ✅ **Colorized CLI Output** - Beautiful, emoji-enhanced console messages
- ✅ **Type-safe** - Full Dart type safety with null safety support
- ✅ **Well-documented** - Extensive inline documentation and examples

#### Examples
- Basic usage example
- Comprehensive feature demonstration
- CLI command demonstrations

#### Software Engineering Principles
- **KISS** - Simple, straightforward API
- **DRY** - No code duplication, reusable utilities
- **YAGNI** - Only essential features, no bloat
- **Single Responsibility** - Each class has one clear purpose
- **Modularization** - Clean separation of concerns

### Dependencies
- `yaml: ^3.1.2` - Parse pubspec.yaml configuration
- `path: ^1.9.0` - Cross-platform path handling
- `args: ^2.5.0` - Command-line argument parsing
- `io: ^1.0.4` - File I/O operations

