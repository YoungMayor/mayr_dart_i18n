# mayr_i18n Examples

This directory contains examples demonstrating how to use the mayr_i18n package.

## Running the Example

```bash
dart run example/mayr_i18n_example.dart
```

## Example Output

```
🌍 MayrI18n Example

English:
  Welcome, Mayor!
  Login
  Invalid credentials

Français:
  Bienvenue, Mayor!
  Connexion
  Identifiants invalides

GenZ:
  Yo Mayor, what's good?
  Sign In
  Wrong login, bruh

🧩 Using String Extension (.tr()):
  Catch you later!
  Your Profile

📋 Available locales:
  en, fr, genz

✅ Example complete!
```

## What the Example Demonstrates

1. **Loading translations** - Using `MayrI18n.instance.load()`
2. **Basic translation** - Using `MayrI18n.instance.tr()` with keys
3. **Placeholder replacement** - Using args parameter to replace `{name}` placeholders
4. **Language switching** - Using `changeLanguage()` to switch between locales
5. **String extension** - Using the convenient `.tr()` extension method
6. **Listing locales** - Getting all available languages

## Key Features Shown

- ✅ Nested key support (e.g., `auth.errors.invalid`)
- ✅ Dynamic placeholder replacement
- ✅ Multiple language support
- ✅ Simple API with extension methods
- ✅ Non-standard languages (GenZ)
